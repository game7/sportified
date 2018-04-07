

interface Env {
  NODE_ENV: string;
  API_BASE: string;
}

interface Process {
  env: Env;
}

declare var process: Process;
