#!./venv/bin/python

import asyncio

import bleak.backends.device
from bleak import BleakScanner

MAC = "MAC_ADDR"
COMPANY_ID = 0x0969

async def main():
    stop_event = asyncio.Event()
    def callback(device: bleak.backends.device.BLEDevice, advertising_data: bleak.backends.scanner.AdvertisementData):
        if device.address == MAC:
            svc = advertising_data.service_data
            if len(svc) == 0:
                return
            data_bytes: bytes = advertising_data.manufacturer_data[COMPANY_ID]
            temp_raw = ((data_bytes[8] & 0b00001111) * 0.1 + (data_bytes[9] & 0b01111111))
            pn_flag = (data_bytes[9] & 0b10000000)
            temperature = temp_raw if pn_flag else -temp_raw
            humidity = data_bytes[10] & 0b01111111
            battery_pct = (svc['0000fd3d-0000-1000-8000-00805f9b34fb'][2] & 0b01111111 )
            print(f"Temperature: {temperature}°C, Humidity: {humidity}%, Battery: {battery_pct}%")
            stop_event.set()

    async with BleakScanner(callback) as scanner:
        await stop_event.wait()

if __name__ == "__main__":
    asyncio.run(main())
