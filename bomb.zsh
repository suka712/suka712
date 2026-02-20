# Loading stuff
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Aliases
alias pn='pnpm'
# Custom prompt: khiem@arx ~ ❯ 
PROMPT='%F{9}%n%f@%F{cyan}%m %F{default}%~%f %F{cyan}❯%f '
# System info
user=$(whoami)
host=$(uname -n)

if [[ -f /etc/os-release ]]; then
    source /etc/os-release && os="$NAME $VERSION"
else
    os="$(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
fi

if [[ -f /proc/uptime ]]; then
    up=$(awk '{print int($1)}' /proc/uptime)
else
    up=$(($(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',')))
fi
uptime="$((up/3600))h$((up%3600/60))m$((up%60))s"

de="${XDG_CURRENT_DESKTOP:-$DESKTOP_SESSION}"

if command -v free &>/dev/null; then
    mem="$(free -h | awk '/^Mem:/ {print $3"/"$2}')"
else
    mem_total=$(sysctl -n hw.memsize)
    mem_used=$((mem_total - $(vm_stat | awk '/free|speculative/ {gsub(/\./,""); s+=$3} END {print s}') * $(pagesize)))
    mem="$(printf "%.1fG/%.1fG" $((mem_used/1073741824)) $((mem_total/1073741824)))"
fi

disk="$(df -h / | awk 'NR==2 {print $3"/"$2}')"

shell="${SHELL##*/}"
if command -v brew &>/dev/null; then
    packages=$(brew list | wc -l)
elif command -v pacman &>/dev/null; then
    packages=$(pacman -Qe | wc -l)
fi
packages="${packages// /}"

battery=$(upower -i "$(upower -e 2>/dev/null | grep BAT)" 2>/dev/null | awk '/percentage/ {print $2}') \
    || battery=$(pmset -g batt 2>/dev/null | grep -o '[0-9]\+%')

colors=(159 153 117 81 75 39 33 27 21)
lines=(
"⣿⣿⣿⣿⣿⣷⣿⣿⣿⡅⡹⢿⠆⠙⠋⠉⠻⠿⣿⣿⣿⣿⣿⣿⣮⠻⣦⡙⢷⡑⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣌⠡⠌⠂⣙⠻⣛⠻⠷⠐⠈⠛⢱⣮⣷⣽⣿ ❯ $user@$host"
"⣿⣿⣿⣿⡇⢿⢹⣿⣶⠐⠁⠀⣀⣠⣤⠄⠀⠀⠈⠙⠻⣿⣿⣿⣦⣵⣌⠻⣷⢝⠦⠚⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣻⣿⣊⡃⠀⣙⠿⣿⣿⣿⣎⢮⡀⢮⣽⣿⣿ ❯ $os$de"
"⢿⣿⣿⣿⣧⡸⡎⡛⡩⠖⠀⣴⣿⣿⣿⠀⠀⠀⠀⠸⠇⠀⠙⢿⣿⣿⣿⣷⣌⢷⣑⢷⣄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣫⠶⠛⠉⠀⠁⠀⠈⠈⠀⠠⠜⠻⣿⣆⢿⣼⣿⣿⣿⣿ ❯ Uptime: $uptime"
"⢐⣿⣿⣿⣿⣧⢧⣧⢻⣦⢀⣹⣿⣿⣿⣇⠀⠄⠀⠀⠀⡀⠀⠈⢻⣿⣿⣿⣿⣷⣝⢦⡹⠷⡙⢿⣿⣿⣿⣿⣿⣿⣿⠈⠁⠀⠀⠀⠁⠀⠀⠀⠱⣶⣄⡀⠀⠈⠛⠜⣿⣿⣿⣿⣿ ❯ Mem: $mem"
"⠀⠊⢫⣿⣏⣿⡌⣼⣄⢫⡌⣿⣿⣿⣿⣿⣦⡈⠲⣄⣤⣤⡡⢀⣠⣿⣿⣿⣿⣿⣿⣷⣼⣍⢬⣦⡙⣿⣿⣿⣿⣿⣯⢁⡄⠀⡀⡀⠀⠄⢈⣠⢪⠀⣿⣿⣿⣦⠀⢉⢂⠹⡿⣿⣿ ❯ Disk: $disk"
"⠀⠀⠄⢹⢃⢻⣟⠙⣿⣦⠱⢻⣿⣿⣿⣿⣿⣿⣷⣬⣍⣭⣥⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡙⢿⣼⡿⣿⣿⣿⣿⣿⣷⣄⠘⣱⢦⣤⡴⡿⢈⣼⣿⣿⣿⣇⣴⣶⣮⣅⢻⣿⡏ ❯ Shell: $shell"
"⠀⠀⠈⠹⣇⢡⢿⡆⠻⣿⣷⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣍⡻⣿⣟⣻⣿⣿⣿⣿⣷⣦⣥⣬⣤⣴⣾⣿⣿⣿⣿⣷⣿⣿⣿⣿⣷⡜⠃ ❯ Packages: $packages"
"⠀⠀⠀⢀⣘⠈⢂⠃⣧⡹⣿⣷⡄⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣅⡙⢿⣟⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⡕⠂ ❯ Battery: $battery"
"⠀⠀⠀⠀⠀⠀⠛⢷⣜⢷⡌⠻⣿⣿⣦⣝⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣹⣷⣦⣹⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠉⠃⠀"
)
num_colors=${#colors[@]}
num_lines=${#lines[@]}
for ((i=1; i<=num_lines; i++)); do
  color_idx=$(( (i - 1) * num_colors / num_lines + 1 ))
  print -P "%F{${colors[$color_idx]}}${lines[$i]}%"
  sleep 0.05
done