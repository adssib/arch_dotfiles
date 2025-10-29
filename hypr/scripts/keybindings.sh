#!/bin/bash
config_file="$HOME/.config/hypr/conf/keybinding.conf"
echo "Reading from: $config_file"
keybinds=""

# Read keybindings
while read -r line
do
    if [[ "$line" == "bind"* ]]; then
        line="$(echo "$line" | sed 's/$mainMod/SUPER/g')"
        line="$(echo "$line" | sed 's/bind = //g')"
        line="$(echo "$line" | sed 's/bindm = //g')"
        line="$(echo "$line" | sed 's/bindl = //g')"
        
        IFS='#'
        read -a strarr <<<"$line"
        kb_str=${strarr[0]}
        cm_str=${strarr[1]}

        IFS=','
        read -a kbarr <<<"$kb_str"
        item="${kbarr[0]} + ${kbarr[1]}"$'  →  '"${cm_str:1}"
        keybinds+=$item$'\n'
    fi
done < "$config_file"

keybinds="${keybinds%$'\n'}"

# Use wofi with proper styling
echo -e "$keybinds" | wofi --dmenu \
    --prompt "Keybindings" \
    --width 800 \
    --height 600 \
    --style ~/.config/wofi/style.css