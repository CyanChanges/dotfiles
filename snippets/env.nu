def !env [name] {
  deno run -A ($env.HOME | path join "dotfiles/utils2/env_mm.ts") $name
}
