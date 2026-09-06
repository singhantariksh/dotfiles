from kittens.tui.handler import result_handler  # type: ignore
from kitty.boss import Boss  # type: ignore


def main(args: list[str]) -> str:
    # Main entry point runs in the child process, we don't need to do anything here
    return ""


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    # is_main_linebuf() is True when at a normal shell prompt.
    # It is False when an alternate screen is active (e.g., inside Neovim, htop, less).
    if not window.screen.is_main_linebuf():
        # We are inside a TUI application. Do nothing so we don't interrupt it.
        return

    action = args[1] if len(args) > 1 else ""

    sources = {
        "scrollback": (
            "@screen_scrollback",
            'call cursor(line("$") - scrolled_by + 1, 0)',
        ),
        "last_cmd": (
            "@last_cmd_output",
            'call cursor(line("$") - scrolled_by, 0)',
        ),
    }

    entry: tuple[str, str] | None = sources.get(action)
    if entry is None:
        return

    stdin_source, cursor_expr = entry

    scroll_cmd = (
        "let kitty_data = $KITTY_PIPE_DATA | "
        'let parts = split(kitty_data, ":") | '
        "let scrolled_by = parts[0] | "
        f"{cursor_expr} | "
        'call feedkeys("zb", "n")'
    )

    boss.call_remote_control(
        window,
        (
            "launch",
            "--type=overlay",
            f"--stdin-source={stdin_source}",
            "nvim",
            "-u",
            "NONE",
            "-i",
            "NONE",
            "-M",
            "-c",
            "set clipboard+=unnamedplus laststatus=0 nospell syntax=",
            "-c",
            "map q :q!<CR>",
            "-c",
            scroll_cmd,
            "-",
        ),
    )
