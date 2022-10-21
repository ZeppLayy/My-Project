import pandas as pd
import numpy as np
import datetime
from datetime import date
import streamlit as st
import math

# Lấy dữ liệu:
def get_input():
    dat = date.today().strftime("%Y-%m-%d")
    start_date = datetime.date(2017, 1, 1)
    end_date = datetime.date.today()
    stocks = ('BID', 'VNM', 'VIC', 'VHM', 'VCB')
    stock_symbol = st.selectbox('Chọn loại cổ phiếu:', stocks)
    return start_date, end_date, stock_symbol

def get_data(symbol, start, end):
    if symbol.upper() == 'BID':
        df = pd.read_csv("C:\\Users\hello\Desktop\PT\BID.csv")
    elif symbol.upper() == 'VNM':
        df = pd.read_csv("C:\\Users\hello\Desktop\PT\VNM.csv")
    elif symbol.upper() == 'VIC':
        df = pd.read_csv("C:\\Users\hello\Desktop\PT\VIC.csv")
    elif symbol.upper() == 'VHM':
        df = pd.read_csv("C:\\Users\hello\Desktop\PT\VHM.csv")
    elif symbol.upper() == 'VCB':
        df = pd.read_csv("C:\\Users\hello\Desktop\PT\VCB.csv")
    else:
        df = pd.DataFrame(columns=['Date','Open','High','Low','Close','Volume'])
#zzz
    start = pd.to_datetime(start)   
    end = pd.to_datetime(end)

    start_row = 0
    end_row = 0

    for i in range(0, len(df)):
        if start < pd.to_datetime(df['Date'][i]):
            start_row = i
            break
    
    for j in range(0, len(df)):
        if end >= pd.to_datetime(df['Date'][len(df)-1-j]):
            end_row = len(df) - 1 - j
            break

    df = df.set_index(pd.DatetimeIndex(df['Date'].values))
    return df.iloc[start_row:end_row + 1, :]

    
start, end, symbol = get_input()
df = get_data(symbol, start, end)

st.header('RAW DATA')
st.write(df.tail())

#--------------
#j = 3
#df = pd.read_csv('BID.csv')
    #start_date = st.sidebar.date_input("Start date", datetime.date(2018, 1, 1))
    #end_date = st.sidebar.date_input("End date", datetime.date.today())



# Dự báo theo ngày/tuần/tháng
df['Date'] = pd.to_datetime(df['Date'])
df = df.set_index('Date')
stocks = ('Ngày', 'Tuần', 'Tháng')
z = st.sidebar.selectbox('Dự báo theo:', stocks)
if z == 'Tuần':
    df = df[datetime.datetime(2017, 1, 2):datetime.datetime.today()].resample('W').mean()
elif z == 'Tháng':
    df = df[datetime.datetime(2017, 1, 2):datetime.datetime.today()].resample('M').mean()
else:
    df = df[datetime.datetime(2017, 1, 2):datetime.datetime.today()]

col = st.sidebar.number_input("Chọn cột dự báo:",min_value=1, max_value = df.shape[1], value=4, step=1)

y = df.values[: , col-1]
a = len(y) - 1
yt = y[a]
y1 = y[0]



# Mô hình dự báo:
#1. Ramdom Walks model-------------------------------------
def diff(y,m):
    tol = 0

    for i in range(len(y)):
        if i < len(y) - 1:
            dyt = m + (y[i+1] - y[i])
            tol +=dyt
    i += i
    return (tol+m)/len(y)


def naive(y, n, m):
    ramdom_walk = []
    for i in range(n):
        ramdom_walkz = (yt) + diff(y, m)*(i+1)
        ramdom_walk.append(ramdom_walkz)
    i += i
    return pd.DataFrame({'Predicted Value':ramdom_walk})
   # c = pd.DataFrame(ramdom_walk)



#2. Moving averages ---------------------------------------------------
def ma(y,j):
    i = 0
    moving_averages = []

    for i in range(len(y) - j):
        window = y[i : i + j] 
        window_average = round(sum(window) / j, 3) 
        moving_averages.append(window_average)  
        i += 1
    return moving_averages


def ma_(y,j):
    window_size = len(y) - j + 1
    
    i = 0
    v = []

    while i < len(y) - window_size + 1:
        if i < len(y):
            window = y[window_size+i-1]
            window_average = window
            v.append(window_average)
            
        i += 1
    return v


def ma_predicted(y,j,n):
    arr = ma_(y,j)
    i = 0
    predicted = []

    while i < n:
        window = arr[i : i + j]
        window_average = np.sum(window) / j
        arr.append(window_average)
        predicted.append(window_average)
        i += 1
    return pd.DataFrame({'Predicted Value':predicted})
#def mea(y,j):
    #return abs(error(y,j).values[:,0])/len(error(y,j))



#3. Simple Exponential smoothing----------------------------------------
def sm(y):
    i = 0
    sm = []

    while i < len(y) - 1:
        if i < len(y):
            window = y[2 + i - 1]
            window_average = window
            sm.append(window_average)    
        i += 1
    return sm


def level(y,alpha):
    i = 0
    level = []
    level.append(y1)
    add = []
    add.append(y1)
    a1 = 0
    while i < len(y) - 1:
        a1 = round((sm(y)[i]*alpha)+(1-alpha)*add[i],3)
        add.append(a1)
        level.append(a1)
        i += 1
    return level


def level2(y,alpha):
    i = 0
    level = []
    level.append(y1)
    add = []
    add.append(y1)
    a1 = 0
    while i < len(y) - 2:
        a1 = round((sm(y)[i]*alpha)+(1-alpha)*add[i],3)
        add.append(a1)
        level.append(a1)
        i += 1
    return level


def sm_predicted(y,n,alpha):
    x = level(y,alpha)
    i = 0
    predicted = []
    for i in range(n):
        arr = x[len(x)-1]
        predicted.append(arr)
        i += 1
    return pd.DataFrame({'Predicted Value':predicted})



#4. Holt's----------------------------------------------
def holt_predicted(x,y,n,alpha,beta):
    i = 0
    a3 = 0
    a4 = 0
    holt = []
    ut = []
    ut.append(y1)
    tren = []
    tren.append(0)
    while i < len(y) - 1:
        a3 = round((x[i]*alpha)+(1-alpha)*(ut[i]+tren[i]),3)
        ut.append(a3)
        a4 = beta*(ut[i +1] - ut[i])+(1-beta)*tren[i]
        tren.append(a4)
        i += 1
        
    for i in range(n):
        holtz = ut[len(ut)-1] + tren[len(tren)-1]*i
        holt.append(holtz)
        i +=1
    return pd.DataFrame({'Predicted Value':holt})

def x(x,alpha,beta):
    i = 0
    a3 = 0
    a4 = 0
    ut = []
    ut.append(y1)
    tren = []
    tren.append(0)
    while i < len(y) - 1:
        a3 = round((x[i]*alpha)+(1-alpha)*(ut[i]+tren[i]),3)
        ut.append(a3)
        a4 = beta*(ut[i +1] - ut[i])+(1-beta)*tren[i]
        tren.append(a4)
        i += 1
    return ut

#5. Tính RMSE & MAPE-------------------------------------------------
def sb(y,j):
    i = 0
    at = []

    while i < len(y) - j:
        if i < len(y):
            window = y[j + i]
            window_average = window
            at.append(window_average)    
        i += 1
    return at


def rmse(x,z):
    rm = 0
    mae = 0
    rmse=0
    i = 0
    for i in range(len(x)):
        erz = round(abs(x[i] - z[i]),3)
        erz2=erz**2
        mae+= erz
        rmse+=erz2
        i+=i
    rm = (math.sqrt(rmse/len(x)))
    return rm


def mape(x,z):
    er = []
    i = 0
    mape = 0
    mp = 0
    for i in range(len(x)):
        erz = round(abs(x[i] - z[i]),3)
        er.append(erz)
        i += i

    for i in range(len(x)):
        erz = round(er[i]/x[i]*100,3)
        mape+=erz
        i += 1
    mp = mape/len(x)
    return mp


#6. Chọn loại dự báo------------------------------------------
def get_input3():
    #start_date = st.sidebar.date_input("Start date", datetime.date(2018, 1, 1))
    #end_date = st.sidebar.date_input("End date", datetime.date.today())
    stocks = ('Ramdom Walk', 'Moving Average', 'Exponential Smoothing', 'Holt')
    stock_symbol = st.sidebar.selectbox('Kỹ thuật dự báo:', stocks)
    return stock_symbol


def get_method(method):
    if method == 'Ramdom Walk': 
        n = st.sidebar.number_input("Số dự báo:",min_value=1, max_value = 100, value=1, step=1)
        m = st.sidebar.slider("m",min_value=-3.0, max_value = 3.0, value=0.0, step=0.01)
        st.header('Giá trị dự báo:')
        st.write(naive(y,n,m))

    elif method == 'Moving Average':
        n = st.sidebar.number_input("Số dự báo:",min_value=1, max_value = 100, value=1, step=1)
        j = st.sidebar.slider("MA",min_value=3, max_value = 50, value=3, step=1)
        st.header('Giá trị dự báo:')
        st.write('RMSE:',rmse(sb(y,j),ma(y,j)))
        st.write('MAPE:',mape(sb(y,j),ma(y,j)),'%')               
        st.write(ma_predicted(y,j,n))


    elif method == 'Exponential Smoothing':
        n = st.sidebar.number_input("Số dự báo:",min_value=1, max_value = 100, value=1, step=1)
        alpha = st.sidebar.slider("alpha",min_value=0.0, max_value = 1.0, value = 0.2, step=0.01)
        st.header('Giá trị dự báo:')
        st.write('RMSE:',rmse(sm(y),level2(y,alpha)))
        st.write('MAPE:',mape(sm(y),level2(y,alpha)),'%')             
        st.write(sm_predicted(y,n,alpha))

    else:
        n = st.sidebar.number_input("Số dự báo:",min_value=1, max_value = 100, value=1, step=1)
        alpha = st.sidebar.slider("alpha",min_value=0.0, max_value = 1.0, value = 0.2, step=0.01)
        beta = st.sidebar.slider("beta",min_value=0.0, max_value = 1.0, value = 0.6, step=0.01)
        st.header('Giá trị dự báo:')
        st.write('RMSE:',rmse(sm(y),x(sm(y),alpha,beta)))
        st.write('MAPE:',mape(sm(y),x(sm(y),alpha,beta)),'%')             
  
        st.write(holt_predicted(sm(y),y,n,alpha,beta))

#7. Kết quả dự báo
method = get_input3()
dk = get_method(method)
st.write(dk)


                    #---------------------------Zepp Layy------------------------------#
