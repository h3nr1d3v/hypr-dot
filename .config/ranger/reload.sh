#!/bin/bash
if pgrep -x "ranger" > /dev/null
then
    ranger --cmd="reload_cwd" --cmd="redraw_window"
fi
