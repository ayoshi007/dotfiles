#!/bin/bash

# Default values
MIN_SPEED=210
MAX_SPEED=1800
OFFSET=240

_usage="
Usage: $0 [OPTIONS]

Note: this command requires root permissions to run options related to nvidia-smi

Options:
    -ra, --reset-all                                        Resets any modifications and exit (requires root)
    -rgc, --reset-graphics-clock                            Resets graphics clock and exit (requires root)
    -rcofs, --reset-clock-offset                            Resets graphics clock offset and exit
    -h, --help                                              Prints this message
"
confirm() {
    prompt="Proceed?"
    if ! [ -z "${1}" ]; then
        prompt="${1}"
    fi
    while true; do
        read -p "${prompt} (y/n): " yn
        case "${yn}" in
            [Yy]|[Yy]es)
                return 0
                ;;
            [Nn]|[Nn]o)
                return 1
                ;;
            *)
                echo "Enter (y)es or (n)o."
                ;;
        esac
    done
}
check_exit() {
    if [[ $? -gt 0 ]]; then
        echo "Operation failed with exit code $?"
        exit $?
    fi
}


usage() {
    echo "${_usage}"
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -h|--help)
        usage
        exit 0
        ;;
    -ra|--reset-all)
        RESET_GRAPHICS_CLOCK=true
        RESET_CLOCK_OFFSET=true
        shift
        ;;
    -rgc|--reset-graphics-clock)
        RESET_GRAPHICS_CLOCK=true
        shift
        ;;
    -rcofs|--reset-clock-offset)
        RESET_CLOCK_OFFSET=true
        shift
        ;;
    *)
        echo "Unknown option $1"
        usage
        exit 1
        ;;
    esac
done

if [ "${RESET_GRAPHICS_CLOCK}" ] || [ "${RESET_CLOCK_OFFSET}" ]; then 
    if [ "${RESET_GRAPHICS_CLOCK}" ]; then
        echo "Resetting graphics clock"
        nvidia-smi -rgc
        check_exit
    fi
    if [ "${RESET_CLOCK_OFFSET}" ]; then
        echo "Settings graphics clock offset to 0"
        nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=0"
        check_exit
    fi
    exit 0
fi

# get clocks and offsets
read -p "Minimum graphics clock (default ${MIN_SPEED}) > " min_speed
min_speed=${min_speed:-"${MIN_SPEED}"}
read -p "Maximum graphics clock (default ${MAX_SPEED}) > " max_speed 
max_speed=${max_speed:-"${MAX_SPEED}"}
read -p "Graphics clock offset (default ${OFFSET}) > " offset 
offset=${offset:-"${OFFSET}"}

echo "
Setting to the below settings:
Minimum graphics clock: ${min_speed} MHz
Maximum graphics clock: ${max_speed} MHz
Graphics clock offset:  ${offset}
"
if ! confirm ; then
    exit 0
fi
echo

# perform edits
echo "Running 'nvidia-smi -pm 1' to set persistence mode..."
nvidia-smi -pm 1
echo
echo "Running 'nvidia-smi -lgc ${min_speed},${max_speed}'..."
nvidia-smi -lgc ${min_speed},${max_speed}
check_exit
echo
echo "Running 'nvidia-settings -a \"[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=${offset}\"'..."
nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=${offset}"
check_exit


