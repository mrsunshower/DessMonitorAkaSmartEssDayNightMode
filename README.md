# Dess Monitor aka SmartEss Day-Night Mode Switch (AI-generated)
Tested ONLY on Powmr 4.2kw 24v with a default WI-FI module

This script is designed to optimize energy usage by automating Dess Monitor inverter modes. It enables charging the battery at cheaper night tariffs and using stored energy during the day, helping reduce electricity costs while ensuring efficient power management.

## Script Description

- Authenticates securely using your credentials.
- Obtains temporary tokens and generates signed API requests.
- Sends commands to switch inverter modes to optimize battery charging using cheaper night tariffs and day usage.

## Parameters and Secrets Configuration

Fill the following parameters precisely:

- `DESS_USER`: Your Dess Monitor/SmartEss login.
- `DESS_PASS`: Your Dess Monitor/SmartEss password.
- `DESS_COMPANY_KEY`: How to find it: Open Developer Tools in your browser (usually by pressing F12). Log in to the https://www.dess-monitor-day-night-mode-switch.com﻿ website using your credentials. Go to the Network tab, filter requests by authSource. Find the URL that contains company-key= and copy that value.
- Device parameters (`DEVICE_PN`, `DEVICE_SN`, `DEVICE_CODE`, `DEVICE_ADDR`): All available in the **Device Info** tab of your Dess Monitor app or web portal.

## How to Use

The script can be run **locally** or automated via **GitHub Actions**.


### Local use:

#### Update credentials:
Replace placeholders in the Configuration section with your actual credentials and device info, but **do not commit sensitive data** (like passwords) to version control.

#### Manual run:
```sh
./dess-monitor-day-night-mode-switch.sh day
./dess-monitor-day-night-mode-switch.sh night
```

#### Automated run:
Use the `cron` command on your local device (Linux desktop, Raspberry Pi, etc.) to schedule it.
Update exec rights
```sh
chmod +x /absolute/path/to/dess-monitor-day-night-mode-switch.sh
```
Run
```sh
crontab -e
```
Add tasks
```sh
0 7 * * * /absolute/path/to/dess-monitor-day-night-mode-switch.sh day  
0 23 * * * /absolute/path/to/dess-monitor-day-night-mode-switch.sh night
```


### GitHub Actions:

#### Update credentials:
Store sensitive data (login, password, company key, device parameters) as **GitHub Secrets** and inject them as environment variables.

#### Automating with GitHub Actions
Check
- .github/workflows/dess_switch_day.yaml
- .github/workflows/dess_switch_night.yaml

Store all sensitive information in **GitHub Secrets** to keep credentials safe while enabling scheduled remote automation.

---

This documentation guides users through setup — whether running locally or using automation — ensuring secure handling of credentials and reliable control of Dess Monitor inverters for efficient energy management.
