// PreToolUse guard for the Bash tool. Blocks recursive forced `rm` and pushes to main/master.
// Reads the hook JSON on stdin; exit 2 with the reason on stderr blocks the call.
import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { basename, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const PROTECTED = new Set(["main", "master"]);
const OPERATORS = new Set([";", "&", "|", "\n", "(", ")"]);
const GIT_VALUE_OPTIONS = new Set(["-C", "-c", "--git-dir", "--work-tree"]);
const PUSH_VALUE_OPTIONS = new Set(["-o", "--push-option", "--repo", "--receive-pack", "--exec"]);
const PUSH_EVERYTHING = new Set(["--all", "--mirror", "--branches"]);
const PREFIXES = new Set(["sudo", "command", "exec", "time"]);

/** Split a shell command into segments of tokens, honouring quotes and backslashes. */
export function segments(command) {
  const result = [];
  let tokens = [];
  let token = null;
  let quote = null;
  const endToken = () => {
    if (token !== null) tokens.push(token);
    token = null;
  };
  const endSegment = () => {
    endToken();
    if (tokens.length > 0) result.push(tokens);
    tokens = [];
  };
  for (let i = 0; i < command.length; i++) {
    const char = command[i];
    if (quote) {
      if (char === quote) quote = null;
      else token += char;
    } else if (char === "'" || char === '"') {
      quote = char;
      token ??= "";
    } else if (char === "\\" && i + 1 < command.length) {
      token = (token ?? "") + command[++i];
    } else if (OPERATORS.has(char)) {
      endSegment();
    } else if (/\s/.test(char)) {
      endToken();
    } else {
      token = (token ?? "") + char;
    }
  }
  endSegment();
  return result;
}

/** Drop leading `VAR=value` assignments and wrappers such as `sudo`. */
function stripPrefixes(tokens) {
  let start = 0;
  while (start < tokens.length && (PREFIXES.has(tokens[start]) || /^\w+=/.test(tokens[start]))) {
    start++;
  }
  return tokens.slice(start);
}

function isForcedRecursiveRm(tokens) {
  if (basename(tokens[0] ?? "") !== "rm") return false;
  const short = tokens.filter((t) => /^-[a-zA-Z]+$/.test(t)).join("");
  const recursive = /[rR]/.test(short) || tokens.includes("--recursive");
  const force = /f/.test(short) || tokens.includes("--force");
  return recursive && force;
}

/** Positional arguments of an option list, skipping options that take a value. */
function positionals(tokens, valueOptions) {
  const result = [];
  for (let i = 0; i < tokens.length; i++) {
    if (valueOptions.has(tokens[i])) i++;
    else if (!tokens[i].startsWith("-")) result.push(tokens[i]);
  }
  return result;
}

/** Parse `git [options] push [args]`; null when the tokens are not a push. */
function parsePush(tokens, cwd) {
  if (basename(tokens[0] ?? "") !== "git") return null;
  let dir = cwd;
  let i = 1;
  for (; i < tokens.length && tokens[i].startsWith("-"); i++) {
    if (tokens[i] === "-C") dir = resolve(dir, tokens[i + 1] ?? "");
    if (GIT_VALUE_OPTIONS.has(tokens[i])) i++;
  }
  if (tokens[i] !== "push") return null;
  const args = tokens.slice(i + 1);
  return { dir, args, refspecs: positionals(args, PUSH_VALUE_OPTIONS).slice(1) };
}

/** The branch a refspec writes to; null means "the current branch". */
function destination(refspec) {
  const target = refspec.replace(/^\+/, "").split(":").pop().replace(/^refs\/heads\//, "");
  return target === "HEAD" || target === "@" ? null : target;
}

function pushesProtected(push, currentBranch) {
  if (push.args.some((arg) => PUSH_EVERYTHING.has(arg))) return true;
  const targets = push.refspecs.length > 0 ? push.refspecs.map(destination) : [null];
  return targets.some((target) => PROTECTED.has(target ?? currentBranch(push.dir)));
}

function gitCurrentBranch(dir) {
  try {
    return execFileSync("git", ["-C", dir, "rev-parse", "--abbrev-ref", "HEAD"], {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    // Not a repository, or no git: there is no current branch to protect.
    return "";
  }
}

/** Return the reason a command is blocked, or null when it may run. */
export function check(command, cwd, currentBranch = gitCurrentBranch) {
  let dir = cwd;
  for (const raw of segments(command)) {
    const tokens = stripPrefixes(raw);
    const shown = raw.join(" ");
    if (tokens[0] === "cd" && tokens[1]) dir = resolve(dir, tokens[1]);
    if (isForcedRecursiveRm(tokens)) {
      return `BLOCKED recursive forced rm: \`${shown}\`. Use a recoverable delete instead (gio trash on Linux).`;
    }
    const push = parsePush(tokens, dir);
    if (push && pushesProtected(push, currentBranch)) {
      return `BLOCKED push to main/master: \`${shown}\`. Pushing main is the user's call: push a feature branch, or end with the exact \`! git push ...\` command for them to run.`;
    }
  }
  return null;
}

function main() {
  const input = JSON.parse(readFileSync(0, "utf8"));
  const reason = check(input.tool_input?.command ?? "", input.cwd ?? process.cwd());
  if (reason) {
    console.error(reason);
    process.exit(2);
  }
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) main();
