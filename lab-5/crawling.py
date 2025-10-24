import yfinance as yf
import pandas as pd

# Lấy dữ liệu cổ phiếu MSFT từ 2013-01-01 đến hiện tại
ticker = "MSFT"
data = yf.download(ticker, start="2013-01-01", end=None)

# Giữ lại các cột quan trọng
data = data[["Close"]]
data.reset_index(inplace=True)

# Đổi tên cột cho dễ đọc
data.rename(columns={"Date": "date", "Close": "close"}, inplace=True)

# Lưu dữ liệu thành file CSV
data.to_csv("MSFT_prices_2013_present.csv", index=False)

print("✅ Dữ liệu đã được lưu thành công:")
print(data.head())
