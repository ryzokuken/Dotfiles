import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { test } from "node:test";
import { fileURLToPath } from "node:url";

import { check } from "../dot_claude/hooks/guard-bash.mjs";

const script = fileURLToPath(new URL("../dot_claude/hooks/guard-bash.mjs", import.meta.url));
const on = (branch) => () => branch;
const blocked = (command, branch = "feature") => check(command, "/repo", on(branch)) !== null;

test("blocks rm with recursive and force flags", () => {
  for (const command of [
    "rm -rf build",
    "rm -fr build",
    "rm -r -f build",
    "rm -Rf build",
    "rm --recursive --force build",
    "sudo rm -rf /opt/x",
    "/bin/rm -rf build",
    "ls && rm -rf build",
    "ls; rm -rf build",
    "ls | xargs echo || rm -rf build",
    "FOO=1 rm -rf build",
    "(rm -rf build)",
  ]) {
    assert.equal(blocked(command), true, command);
  }
});

test("allows rm that is not both recursive and forced, and rm as plain text", () => {
  for (const command of [
    "rm file.txt",
    "rm -r build",
    "rm -f file.txt",
    "gio trash build",
    'git commit -m "stop using rm -rf in scripts"',
    "echo 'rm -rf build'",
    "pnpm run rm-cache -rf",
  ]) {
    assert.equal(blocked(command), false, command);
  }
});

test("blocks a push whose refspec targets main or master", () => {
  for (const command of [
    "git push origin main",
    "git push origin master",
    "git push -u origin main",
    "git push origin HEAD:main",
    "git push origin feature:refs/heads/main",
    "git push --force origin +main",
    "git push origin feature main",
    "git -C /other push origin main",
    "git add . && git commit -m x && git push origin main",
    "git push --all origin",
    "git push --mirror",
  ]) {
    assert.equal(blocked(command), true, command);
  }
});

test("blocks a push with no refspec while on main or master", () => {
  assert.equal(blocked("git push", "main"), true);
  assert.equal(blocked("git push origin", "master"), true);
  assert.equal(blocked("git push origin HEAD", "main"), true);
  assert.equal(blocked("git push -o ci.skip", "main"), true);
});

test("allows pushes of other branches, whatever words they contain", () => {
  for (const command of [
    "git push",
    "git push origin",
    "git push origin HEAD",
    "git push -u origin domain-modeling-3",
    "git push origin maintenance",
    "git push origin fix-main-menu",
    "git push origin main-nav:main-nav",
    'git commit -m "push main later" && git push origin feature',
    "git push origin feature && echo pushed, main untouched",
    "git log origin/main..HEAD",
    "gh pr create --base main",
  ]) {
    assert.equal(blocked(command), false, command);
  }
});

test("allows pushing a named feature branch from a checkout that sits on main", () => {
  assert.equal(blocked("git push origin feature", "main"), false);
});

test("resolves the branch in the directory the command moves to", () => {
  const branchOf = (dir) => (dir === "/repo/wt" ? "main" : "feature");
  assert.notEqual(check("cd wt && git push", "/repo", branchOf), null);
  assert.notEqual(check("git -C wt push", "/repo", branchOf), null);
  assert.equal(check("cd elsewhere && git push", "/repo", branchOf), null);
});

test("the reason names the operation, the input and the fix", () => {
  assert.match(check("rm -rf build", "/repo", on("x")), /rm.*`rm -rf build`.*gio trash/);
  assert.match(check("git push origin main", "/repo", on("x")), /push.*`git push origin main`.*! git push/);
});

test("as a hook: exit 2 with the reason on stderr when blocked, exit 0 otherwise", () => {
  const run = (command) =>
    spawnSync(process.execPath, [script], {
      input: JSON.stringify({ tool_input: { command }, cwd: "/" }),
      encoding: "utf8",
    });
  const denied = run("rm -rf build");
  assert.equal(denied.status, 2);
  assert.match(denied.stderr, /BLOCKED/);
  const allowed = run("echo hello");
  assert.equal(allowed.status, 0);
  assert.equal(allowed.stderr, "");
});
