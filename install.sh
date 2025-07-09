#!/bin/bash
# --- Configuration ---
ROS2_WORKSPACE_PATH="/opt/ros2-csi-msgs"
PACKAGE_NAME="wifi_msgs"
ROS2_INSTALL_PATH="/opt/ros/$ROS_DISTRO" # Adjust this if your ROS2 install path is different
USER=$(whoami)
USER_HOME="$HOME"
SHELL_RC_FILE="$USER_HOME/.bashrc"
GITHUB_REPO_URL="https://github.com/kuederleR/ros2-csi-msgs.git"

echo "--- Starting ROS2 Environment Setup Script ---"
source /opt/ros/$ROS_DISTRO/setup.bash || { echo "Error: Could not source ROS2 setup.bash. Please ensure ROS2 is installed correctly. Exiting."; exit 1; }

cd "/opt" || { echo "Error: Could not change to /opt directory. Exiting."; exit 1; }
# 1. Clone the custom message package if it doesn't exist
if [ ! -d "$PACKAGE_NAME" ]; then
  echo "Package '$PACKAGE_NAME' not found. Cloning from $GITHUB_REPO_URL..."
  sudo git clone "$GITHUB_REPO_URL" || { echo "Error: Git clone failed. Please check the repository URL and your network connection. Exiting."; exit 1; }
  echo "Repository cloned successfully."
else
  echo "Package '$PACKAGE_NAME' already exists. Skipping clone."
fi

# Navigate back to the root of the workspace for building
cd "$ROS2_WORKSPACE_PATH" || { echo "Error: Could not change to workspace root directory. Exiting."; exit 1; }

# 2. Build the custom message package
echo "Building package: $PACKAGE_NAME"
sudo bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && colcon build --packages-select \"$PACKAGE_NAME\"" || { echo "Error: colcon build failed. Please check the build output. Exiting."; exit 1; }
echo "Package build complete."

# 3. Add sourcing to shell RC file (e.g., ~/.bashrc)
echo "Updating $SHELL_RC_FILE to automatically source workspace..."

# Check if the sourcing lines already exist to prevent duplicates
if ! grep -q "### ROS2 Workspace Sourcing - $PACKAGE_NAME ###" "$SHELL_RC_FILE"; then
  echo "" >> "$SHELL_RC_FILE"
  echo "# --- Added by setup_my_ros2_env.sh on $(date) ---" >> "$SHELL_RC_FILE"
  echo "### ROS2 Workspace Sourcing - $PACKAGE_NAME ###" >> "$SHELL_RC_FILE"
  echo "# Source the main ROS2 installation" >> "$SHELL_RC_FILE"
  echo "source $ROS2_INSTALL_PATH/setup.bash" >> "$SHELL_RC_FILE"
  echo "# Source your workspace's setup file (after ROS2 base install)" >> "$SHELL_RC_FILE"
  echo "source $ROS2_WORKSPACE_PATH/install/setup.bash" >> "$SHELL_RC_FILE"
  echo "# --- End ROS2 Workspace Sourcing ---" >> "$SHELL_RC_FILE"
  echo "Added sourcing commands to $SHELL_RC_FILE."
else
  echo "Sourcing commands for $PACKAGE_NAME already present in $SHELL_RC_FILE. Skipping addition."
fi

echo "--- Setup Complete ---"
echo "Please restart your terminal or run 'source $SHELL_RC_FILE' for changes to take effect."
echo "You can now verify by opening a new terminal and checking 'ros2 interface show $PACKAGE_NAME/msg/CSI'."

source $SHELL_RC_FILE