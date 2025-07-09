# wifi_msgs/msg/CSI.msg
# Custom message for WiFi Channel State Information (CSI) data

std_msgs/Header header          # Standard header for timestamp and frame ID

# Basic WiFi information
string mac                      # CSI data mac address
int32 rssi                      # Received Signal Strength Indicator (dBm)

# CSI Matrix dimensions
uint8 nss                       # Number of spatial streams (e.g., 1, 2, 3)
uint8 nrx                       # Number of receive antennas (e.g., 1, 2, 3)
uint16 num_subcarriers          # Number of subcarriers (e.g., 56, 128, 256)

# CSI Data - Real and Imaginary Parts
# The CSI matrix is typically complex. We'll store real and imaginary parts separately.
# The size of these arrays will be nss * nrx * num_subcarriers
float32[] csi_complex           # Raw complex data
float32[] csi_amplitude         # Amplitude part of the CSI matrix
float32[] csi_phase             # Phase part of the CSI matrix

# Optional: Additional CSI metadata
uint8 channel                   # WiFi channel number (e.g., 1-14 for 2.4GHz, 36-165 for 5GHz)
uint8 bandwidth                 # Bandwidth (e.g., 20MHz, 40MHz, 80MHz) - use enum or specific values if known