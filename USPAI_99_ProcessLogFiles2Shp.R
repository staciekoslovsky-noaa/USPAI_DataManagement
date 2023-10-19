# USPAI: Process flight log
# S. Koslovsky

# Define variables
log_folder <- 
  #'F:\\shemya_2023\\FlightLogs_FromSam\\'
  'C:\\Users\\Stacie.Hardy\\Desktop\\shemya_2023\\FlightLogs_FromSam\\'
log_file <- 
  #'Piccolo 5274 Tue Sep 12 11-44-56 2023.log'
  #'Piccolo 5274 Fri Sep 15 18-55-38 2023.log'
  'Piccolo 5274 Tue Sep 19 13-08-30 2023.log'
year_filter <- 2023
month_filter <- 9
day_filter <- 
  #list(12, 13)
  #list(15, 16)
  list(19, 20)
export_folder <- 
  #'F:\\shemya_2023\\FlightLogs_ToShp\\'
  'C:\\Users\\Stacie.Hardy\\Desktop\\shemya_2023\\FlightLogs_ToShp\\'
export_file <- 
  #'flightLog_20230912_fl02tofl04.shp'
  #'flightLog_20230915_fl05.shp'
  'flightLog_20230919_fl10tofl11.shp'

# Create functions -----------------------------------------------
# Function to install packages needed
install_pkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Install libraries ----------------------------------------------

install_pkg("sf")
install_pkg("tidyverse")

# Process data to shapefile -----------------------------------------------
setwd(log_folder)
log <- read.table(log_file, skip = 1, sep = ' ')
colnames(log) <- tolower(c('Clock_ms', 'Year', 'Month', 'Day', 'Hours', 'Minutes', 'Seconds',
                   'Lat_rad', 'Lon_rad', 'Height_m', 'VNorth_mps', 'VEast_mps', 'VDown_mps',
                   'GroundSpeed_mps', 'Direction_rad', 'Status', 'NumSats', 'VisibleSats', 'PDOP',
                   'InputV_v', 'InputC_a', 'ServoV_v', 'ServoC_a', 'FirstStageFail',
                   'FiveDFail', 'FiveAFail', 'CPUFail', 'GPSFail', 'BoxTemp_C', 'BaroAlt_m', 
                   'TAS_mps', 'OAT_C', 'Static_Pa', 'Dynamic_Pa', 'P_radps', 'Q_radps', 'R_radps',
                   'Xaccel_mps2', 'Yaccel_mps2', 'Zaccel_mps2', 'Roll_rad', 'Pitch_rad', 'Yaw_rad', 
                   'MagHdg_rad', 'AGL_m', 'LeftRPM', 'RightRPM', 'Fuel_kg', 'FuelFlow_gph',
                   'WindSouth_mps', 'WindWest_mps', 'UplinkRatio_ppct', 'DownlinkRatio_ppct', 'RSSI_dBm', 
                   'Surface0', 'Surface1', 'Surface2', 'Surface3', 'Surface4', 'Surface5', 'Surface6', 'Surface7', 
                   'Surface8', 'Surface9', 'Surface10', 'Surface11', 'Surface12', 'Surface13', 'Surface14', 
                   'Surface15', 'P_Bias_radps', 'Q_Bias_radps', 'R_Bias_radps', 'AX_Bias_mps2', 'AY_Bias_mps2', 
                   'AZ_Bias_mps2', 'MagX_mGauss', 'MagY_mGauss', 'MagZ_mGauss', 'AP_Global', 'MA_Mode', 
                   'AP_Mode', 'WeightOnWheel', 'TrackerStatus', 'TrackerTarget', 'Orbit', 'LoopStatus0', 
                   'LoopTarget0', 'LoopStatus1', 'LoopTarget1', 'LoopStatus2', 'LoopTarget2', 'LoopStatus3', 
                   'LoopTarget3', 'LoopStatus4', 'LoopTarget4', 'LoopStatus5', 'LoopTarget5', 'LoopStatus6', 
                   'LoopTarget6' # , 'LoopStatus7', 'LoopTarget7', 'AltCtrl', 'Track_X_m', 'Track_Y_m',
                   # 'Track_Z_m', 'Track_VX_mps', 'Track_VY_mps', 'Track_VZ_mps', 'ExtADC0', 'ExtADC1', 
                   # 'ExtADC2', 'ExtADC3', 'NavMode', 'PosGood', 'VelGood', 'BaroGood', 'TASGood', 'AGLGood', 
                   # 'MagGood', 'YawGood', 'AttGood', 'GyroGood', 'AccelGood', 'MagBiasGood', 'WindGood', 'GPSWeek', 
                   # 'GPSITOW', 'MBTime_ms', 'MBLag_ms', 'MBSolnType', 'MBETA_s', 'MBHead_rad', 'MBNorth_m', 
                   # 'MBEast_m', 'MBDown_m', 'MBCross_m', 'MBBelow_m', 'MBLat_rad', 'MBLon_rad', 'MBAlt_m', 
                   # 'GSLat_rad', 'GSLon_rad', 'GSHeight_m', 'GSVNorth_mps', 'GSVEast_mps', 'GSVDown_mps', 
                   # 'GSGroundSpeed_mps', 'GSDirection_rad', 'GSStatus', 'GS_RSSI', 'Deadman', 'EngKill', 'Drop', 
                   # 'Lights', 'Parachute', 'Brakes', 'GPSTimeout', 'CommTimeout', 'Boundary', 'FlightTimer', 
                   # 'FlightTerm', 'AeroTerm', 'UserAction0', 'UserAction1', 'UserAction2', 'UserAction3', 
                   # 'UserAction4', 'UserAction5', 'UserAction6', 'UserAction7', 'L_CHT_A', 'L_CHT_B', 'L_EGT_A', 
                   # 'L_EGT_B', 'L_IAT', 'L_Volts', 'L_MAP', 'L_InjectTime', 'L_InjectAngle', 'L_TPS', 'L_FuelPress', 
                   # 'L_AFR', 'L_AFRcomp', 'L_EngineTime_hrs', 'L_ECU_ERR_0', 'L_ECU_ERR_1', 'L_ECU_MODE', 'L_ECU_SerialNo', 
                   # 'R_CHT_A', 'R_CHT_B', 'R_EGT_A', 'R_EGT_B', 'R_IAT', 'R_Volts', 'R_MAP', 'R_InjectTime', 'R_InjectAngle', 
                   # 'R_TPS', 'R_FuelPress', 'R_AFR', 'R_AFRcomp', 'R_EngineTime_hrs', 'R_ECU_ERR_0', 'R_ECU_ERR_1', 
                   # 'R_ECU_MODE', 'R_ECU_SerialNo', 'PilotPrcnt_pct', 'PilotRate_Hz', 'GSPilotPrcnt_pct', 'GSPilotRate_Hz', 
                   # 'AlignHdg_rad', 'AlignHdgSigma_rad', 'AlignSolnType', 'ResidualPosNorth_m', 'ResidualPosEast_m', 
                   # 'ResidualPosDown_m', 'ResidualVelNorth_mps', 'ResidualVelEast_mps', 'ResidualVelDown_mps', 
                   # 'CPU_Load', 'AltUsed_m'
                   ))
log <- log %>%
  filter(year == year_filter,
         month == month_filter, 
         day %in% day_filter) %>%
  mutate(direction_deg = direction_rad * 180 / pi,
         roll_deg = roll_rad * 180 / pi,
         pitch_deg = pitch_rad * 180 / pi,
         yaw_deg = yaw_rad * 180 / pi,
         maghdg_deg = maghdg_rad * 180 / pi,
         lat_deg = lat_rad * 180 / pi,
         lon_deg = lon_rad * 180 / pi) %>%
  select(tolower(c('Clock_ms', 'Year', 'Month', 'Day', 'Hours', 'Minutes', 'Seconds',
                   'Lat_deg', 'Lon_deg', 'Height_m', 'VNorth_mps', 'VEast_mps', 'VDown_mps',
                   'GroundSpeed_mps', 'Direction_deg', 'Status', 'NumSats', 'VisibleSats', 'BaroAlt_m', 
                   'Roll_deg', 'Pitch_deg', 'Yaw_deg', 'MagHdg_deg', 'AGL_m', 
                   'WindSouth_mps', 'WindWest_mps'))) %>%
  sf::st_as_sf(coords = c("lon_deg", "lat_deg"), crs = 4326)
  # sf::st_transform(crs = 3338)

setwd(export_folder)
sf::st_write(log, export_file, append = FALSE)
