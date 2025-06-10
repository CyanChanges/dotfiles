export-env {
$env.PATH = r#'/home/cyan/.rye/shims:/home/cyan/.local/share/zinit/plugins/starship---starship:/home/cyan/.config/carapace/bin:/home/cyan/.bun/bin:/home/cyan/.deno/bin:/home/cyan/.asdf/shims:/usr/lib/safe-rm:/home/cyan/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/opt/android-ndk:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/opt/android-sdk/tools/bin:/opt/cuda/bin:/opt/cuda/nsight_compute:/opt/cuda/nsight_systems/bin:/home/cyan/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/rustup/bin:/home/cyan/.local/share/JetBrains/Toolbox/scripts:/home/cyan/.local/bin:/home/cyan/go/bin:/home/cyan/.cargo/bin:/home/cyan/.local/share/JetBrains/Toolbox/scripts:/home/cyan/.nix-profile/bin'#

  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field --ignore-errors | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/usr/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/usr/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/usr/bin/mise" $command ...$rest
  }
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if $var.name == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}

def --env mise_hook [] {
  ^"/usr/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

