if ping pve01.home >/dev/null; then 
  PM_API_URL="pve01.home:8006/api2/json" 
else 
  PM_API_URL="pve01:8006/api2/json" 
fi

echo $PM_API_URL
