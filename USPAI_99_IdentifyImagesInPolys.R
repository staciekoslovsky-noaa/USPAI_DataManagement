# USPAI: Generate image lists for images that overlap survey polygons
# S. Koslovsky

# Define variables
project_folder <- 
  #'F:\\shemya_2023\\Data\\'
  'C:\\Users\\Stacie.Hardy\\Desktop\\shemya_2023\\Data\\'
project <- 
  #'shemya_test_2023'
  'uspai_2023'
flight <- 'fl11'
survey_polys <- 
  #'F:\\shemya_2023\\\\Shapefiles\\USPAI_survey_polygons.shp'
  'C:\\Users\\Stacie.Hardy\\Desktop\\shemya_2023\\Shapefiles\\USPAI_survey_polygons.shp'
export_folder <- 
  #'F:\\shemya_2023\\ImagesInSurveyPolygons\\'
  'C:\\Users\\Stacie.Hardy\\Desktop\\shemya_2023\\ImagesInSurveyPolygons\\'

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

process_shp <- function(shape)
{
  shape <- sf::st_read(shape)
  shape <- shape %>%
    rename(
      geom = geometry, 
      image_name = image_file
    ) %>%
    mutate(id = 1:n(),
           image_name = as.character(image_name),
           effort = as.character(effort),
           trigger = as.character(trigger),
           reviewed = as.character(reviewed),
           fate = as.character(fate)) %>%
    mutate(flight = str_extract(image_name, "fl[0-9][0-9]"),
           camera_view = substring(str_extract(image_name, "_[A-Z]_"), 2, 2),
           dt = str_extract(image_name, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]"),
           image_type = ifelse(grepl("rgb", image_name) == TRUE, "rgb_image", 
                               ifelse(grepl("ir", image_name) == TRUE, "ir_image"))
    ) %>%
    select(id, flight, camera_view, dt, image_type, image_name, time, latitude, longitude, altitude, heading, pitch, roll, effort, trigger, reviewed, fate, geom)
}

# Install libraries ----------------------------------------------

install_pkg("sf")
install_pkg("tidyverse")

# Read data from shapefiles ----------------------------------------------
survey_polys <- sf::st_read(survey_polys)

shp_wd <- paste0(project_folder, '\\', project, '\\', flight, '\\processed_results\\fov_shapefiles')
setwd(shp_wd)

center_rgb <- process_shp(paste0(flight, "_center_rgb.shp"))
left_rgb <- process_shp(paste0(flight, "_left_rgb.shp"))
right_rgb <- process_shp(paste0(flight, "_right_rgb.shp"))

center_ir <- process_shp(paste0(flight, "_center_ir.shp")) %>%
  st_drop_geometry()
left_ir <- process_shp(paste0(flight, "_left_ir.shp")) %>%
  st_drop_geometry()

# Identify images that overlap survey polygons
center_rgb_i <- st_intersection(center_rgb, survey_polys) %>%
  select(flight, camera_view, dt, image_name) %>%
  st_drop_geometry()
left_rgb_i <- st_intersection(left_rgb, survey_polys) %>%
  select(flight, camera_view, dt, image_name) %>%
  st_drop_geometry()
right_rgb_i <- st_intersection(right_rgb, survey_polys) %>%
  select(flight, camera_view, dt, image_name) %>%
  st_drop_geometry()

# Match color to thermal
center_rgb_i_withIR <- center_rgb_i %>%
  inner_join(center_ir, by = c("flight", "camera_view", "dt"))
left_rgb_i_withIR <- left_rgb_i %>%
  inner_join(left_ir, by = c("flight", "camera_view", "dt"))

# Remove all the excess
rm(center_ir, center_rgb, center_rgb_i,
   left_ir, left_rgb, left_rgb_i,
   right_rgb,
   survey_polys, shp_wd)

# Export data
center_rgb_out <- center_rgb_i_withIR %>%
  select(image_name.x) %>%
  arrange(image_name.x)
write.table(center_rgb_out, paste0(export_folder, project, '_', flight, '_C_rgb_images_', format(Sys.time(), "%Y%m%d"), '.txt'), quote = FALSE, col.names = FALSE, row.names = FALSE)

center_ir_out <- center_rgb_i_withIR %>%
  select(image_name.y) %>%
  arrange(image_name.y)
write.table(center_ir_out, paste0(export_folder, project, '_', flight, '_C_ir_images_', format(Sys.time(), "%Y%m%d"), '.txt'), quote = FALSE, col.names = FALSE, row.names = FALSE)

left_rgb_out <- left_rgb_i_withIR %>%
  select(image_name.x) %>%
  arrange(image_name.x)
write.table(left_rgb_out, paste0(export_folder, project, '_', flight, '_L_rgb_images_', format(Sys.time(), "%Y%m%d"), '.txt'), quote = FALSE, col.names = FALSE, row.names = FALSE)

left_ir_out <- left_rgb_i_withIR %>%
  select(image_name.y) %>%
  arrange(image_name.y)
write.table(left_ir_out, paste0(export_folder, project, '_', flight, '_L_ir_images_', format(Sys.time(), "%Y%m%d"), '.txt'), quote = FALSE, col.names = FALSE, row.names = FALSE)

right_rgb_out <- right_rgb_i %>%
  select(image_name) %>%
  arrange(image_name)
write.table(right_rgb_out, paste0(export_folder, project, '_', flight, '_R_rgb_images_', format(Sys.time(), "%Y%m%d"), '.txt'), quote = FALSE, col.names = FALSE, row.names = FALSE)