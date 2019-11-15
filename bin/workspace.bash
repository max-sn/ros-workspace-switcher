#!/bin/bash

function usage {
cat <<HELP_USAGE

usage: workspace [-h] WORKSPACE

required arguments:
    WORKSPACE  the name of the workspace

optional arguments:
    -h         display this help instruction

when succesfully switched workspace:
    use 'ws' to cd to workspace
    use 'cm' to catkin_make
    use 'cb' to catkin build (if catkin-tools is installed)
    use 'src' to source the workspace's setup.bash

HELP_USAGE
}

# Workspace is (probably) the only argument
ws="$1"

# Check if user has already appended "_ws", if not, append it
if [[ $ws == *_ws ]]; then
    ws_path="/home/${USER}/${ws}"
else
    ws_path="/home/${USER}/${ws}_ws"
fi

if [ -d "$ws_path" ]; then
    # Source ROS installation
    source /opt/ros/kinetic/setup.bash

    if [ -f "${ws_path}/devel/setup.bash" ]; then
        source ${ws_path}/devel/setup.bash
    else
        echo "Chosen folder does not have /devel/setup.bash"
        echo "Please build or make the workspace and source afterwards."
    fi
    alias src="source ${ws_path}/devel/setup.bash"
    alias ws="cd ${ws_path}"
    alias cm="(cd ${ws_path};catkin_make;src)"
    if command -v catkin >/dev/null; then
        alias cb="(cd ${ws_path};catkin build;src)"
    fi
    echo "Succesfully switched workspace."
elif [[ "${ws}" == "-h" ]]; then
    usage
elif [ -z "$ws" ]; then
    echo "No workspace name provided."
    usage
else
    echo "No such workspace found, please try again."
    usage
fi

if [ "$ws" == "mavric" ]; then
    . /usr/share/gazebo/setup.sh
    export GAZEBO_MODEL_PATH=$ws_path/src/ardupilot_gazebo/models:${GAZEBO_MODEL_PATH}
    export GAZEBO_MODEL_PATH=$ws_path/src/ardupilot_gazebo/models_gazebo:${GAZEBO_MODEL_PATH}
    export GAZEBO_RESOURCE_PATH=$ws_path/src/ardupilot_gazebo/worlds:${GAZEBO_RESOURCE_PATH}
fi