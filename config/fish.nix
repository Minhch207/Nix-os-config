{ pkgs, ... }:

{
  # Cài thêm acpi nếu bạn dùng laptop để prompt hiển thị pin
  home.packages = with pkgs; [
    acpi
  ];

  # Khai báo biến môi trường chuẩn thông qua Home Manager
  home.sessionVariables = {
    EDITOR = "nvim";
    FLAG = "DIT-ME-MAY-CHAN-BO-MAY-DE";
  };

  programs.fish = {
    enable = true;

    # 1. Cấu hình khởi động (config.fish + Theme colors)
    interactiveShellInit = ''
      # Tắt greeting của fish
      set -g fish_greeting ""

      # --- Bắt đầu Theme Colors (từ fish_frozen_theme.fish) ---
      set --global fish_color_autosuggestion 707A8C
      set --global fish_color_cancel -r
      set --global fish_color_command 5CCFE6
      set --global fish_color_comment 5C6773
      set --global fish_color_cwd 73D0FF
      set --global fish_color_cwd_root red
      set --global fish_color_end F29E74
      set --global fish_color_error FF3333
      set --global fish_color_escape 95E6CB
      set --global fish_color_hg_added green
      set --global fish_color_hg_clean green
      set --global fish_color_hg_copied magenta
      set --global fish_color_hg_deleted red
      set --global fish_color_hg_dirty red
      set --global fish_color_hg_modified yellow
      set --global fish_color_hg_renamed magenta
      set --global fish_color_hg_unmerged red
      set --global fish_color_hg_untracked yellow
      set --global fish_color_history_current --bold
      set --global fish_color_host normal
      set --global fish_color_host_remote yellow
      set --global fish_color_keyword 5CCFE6
      set --global fish_color_match F28779
      set --global fish_color_normal CBCCC6
      set --global fish_color_operator FFCC66
      set --global fish_color_option CBCCC6
      set --global fish_color_param CBCCC6
      set --global fish_color_quote BAE67E
      set --global fish_color_redirection D4BFFF
      set --global fish_color_search_match --background=FFCC66
      set --global fish_color_selection --background=FFCC66
      set --global fish_color_status red
      set --global fish_color_user brgreen
      set --global fish_color_valid_path --underline
      set --global fish_pager_color_background
      set --global fish_pager_color_completion normal
      set --global fish_pager_color_description B3A06D yellow
      set --global fish_pager_color_prefix normal --bold --underline
      set --global fish_pager_color_progress brwhite --background=cyan
      set --global fish_pager_color_secondary_background
      set --global fish_pager_color_secondary_completion
      set --global fish_pager_color_secondary_description
      set --global fish_pager_color_secondary_prefix
      set --global fish_pager_color_selected_background --background=FFCC66
      set --global fish_pager_color_selected_completion
      set --global fish_pager_color_selected_description
      set --global fish_pager_color_selected_prefix
      # --- Kết thúc Theme Colors ---
    '';

    # 2. Khai báo các hàm (Prompt + Wrapper Yazi)
    functions = {
      # Custom prompt của bạn
      fish_prompt = ''
        set -l retc red
        test $status = 0; and set retc green

        set -q __fish_git_prompt_showupstream
        or set -g __fish_git_prompt_showupstream auto

        function _nim_prompt_wrapper
            set retc $argv[1]
            set -l field_name $argv[2]
            set -l field_value $argv[3]

            set_color normal
            set_color $retc
            echo -n '─'
            set_color -o green
            echo -n '['
            set_color normal
            test -n $field_name
            and echo -n $field_name:
            set_color $retc
            echo -n $field_value
            set_color -o green
            echo -n ']'
        end

        set_color $retc
        echo -n '┬─'
        set_color -o green
        echo -n [

        if functions -q fish_is_root_user; and fish_is_root_user
            set_color -o red
        else
            set_color -o yellow
        end

        echo -n $USER
        set_color -o white
        echo -n @

        if test -z "$SSH_CLIENT"
            set_color -o blue
        else
            set_color -o cyan
        end

        echo -n (prompt_hostname)
        set_color -o white
        echo -n :(prompt_pwd)
        set_color -o green
        echo -n ']'

        # Date
        _nim_prompt_wrapper $retc ''' (date +%X)

        # Vi-mode
        function fish_mode_prompt
        end

        if test "$fish_key_bindings" = fish_vi_key_bindings
            or test "$fish_key_bindings" = fish_hybrid_key_bindings
            set -l mode
            switch $fish_bind_mode
                case default
                    set mode (set_color --bold red)N
                case insert
                    set mode (set_color --bold green)I
                case replace_one
                    set mode (set_color --bold green)R
                    echo '[R]'
                case replace
                    set mode (set_color --bold cyan)R
                case visual
                    set mode (set_color --bold magenta)V
            end
            set mode $mode(set_color normal)
            _nim_prompt_wrapper $retc ''' $mode
        end

        # Virtual Environment
        set -q VIRTUAL_ENV_DISABLE_PROMPT
        or set -g VIRTUAL_ENV_DISABLE_PROMPT true
        set -q VIRTUAL_ENV
        and _nim_prompt_wrapper $retc V (path basename "$VIRTUAL_ENV")

        # git
        set -l prompt_git (fish_git_prompt '%s')
        test -n "$prompt_git"
        and _nim_prompt_wrapper $retc G $prompt_git

        # Battery status
        type -q acpi
        and acpi -a 2>/dev/null | string match -rq off
        and _nim_prompt_wrapper $retc B (acpi -b | cut -d' ' -f 4-)

        # New line
        echo

        # Background jobs
        set_color normal

        for job in (jobs)
            set_color $retc
            echo -n '│ '
            set_color brown
            echo $job
        end

        set_color normal
        set_color $retc
        echo -n '╰─>'
        set_color -o red
        echo -n '$ '
        set_color normal
      '';
    };
  };
}
