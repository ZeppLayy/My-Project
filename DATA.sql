USE DU_LICH
GO

CREATE TABLE KHACH_HANG
(
	Ma_Khach_Hang varchar(10) primary key,
	Ten_Khach_Hang nvarchar(100),
	CMND_CCCD varchar(20),
	Ngay_Sinh date,
	Gioi_Tinh nvarchar(10),
	Dia_Chi nvarchar(100),
	SDT varchar(11),
	Email varchar(20),
	Nghe_Nghiep nvarchar(20)
)
GO

CREATE TABLE LOAI_HINH
(
    Ma_Loai_Hinh varchar(10) primary key,
	Ten_Loai_Hinh nvarchar(100),
	Dac_Diem nvarchar(100),
	Danh_Gia float	
)	 
GO

CREATE TABLE HINH_THUC_DI_CHUYEN
(
	Ma_HTDC varchar(10) primary key,
	Ten_HTDC nvarchar(100),
	Mo_ta nvarchar(100)
)
GO

CREATE TABLE DIA_DIEM
(	
	Ma_DD varchar(10) primary key,
	Ten_Dia_Diem nvarchar(100),
	Diem_noi_bat nvarchar(100),
	Danh_Gia float,
	Ma_HTDC varchar(10) not null,

	
)
GO 

CREATE TABLE HUONG_DAN_VIEN
(
	Ma_HDV varchar(10) primary key,
	Ten_HDV nvarchar(100),
	Nick_name nvarchar(100),
	Ngay_sinh date,
	Gioi_tinh nvarchar(10),
	SDT varchar(11),
	Diem_so int
)
GO

CREATE TABLE TOUR
(
	Ma_Tour varchar(10) primary key,
	Ten_Tour nvarchar(100),
	Gia_Tour int,
	Ma_Loai_Hinh varchar(10) not null,
	Ma_HDV varchar(10) not null,
	So_ngay int,
	So_dem int,
	Trang_Thai nvarchar(20),
	So_Luong_Nhan int,
	Noi_khoi_hanh nvarchar(50),

	foreign key(Ma_HDV) references HUONG_DAN_VIEN(Ma_HDV),
	foreign key(Ma_Loai_Hinh) references LOAI_HINH(Ma_Loai_Hinh)
) 
GO

CREATE TABLE LICH_TRINH
(
	Ma_Tour varchar(10) not null,
	Ma_DD varchar(10) not null,
	Thoi_gian_khoi_hanh datetime,
	Thoi_gian_nghi_ngoi datetime,
	
	primary key (Ma_tour, Ma_DD),
	foreign key(Ma_Tour) references TOUR(Ma_Tour),
	foreign key(Ma_DD) references DIA_DIEM(Ma_DD)
)
GO

CREATE TABLE DANG_KI_TOUR
( 
	Ma_khach_hang varchar(10) not null,
	Ma_tour varchar(10) not null,
	Ma_dang_ky varchar(10) not null,
	So_luong_ve int,

	primary key (Ma_dang_ky, Ma_khach_hang, Ma_Tour),
	foreign key(Ma_khach_hang) references KHACH_HANG(Ma_khach_hang),
	foreign key(Ma_Tour) references TOUR(Ma_Tour)
)
GO


--Nhập dữ liệu cho bảng Loại hình:
INSERT INTO LOAI_HINH VALUES ('DLTN', N'Du lịch thiên nhiên', N'Hòa mình vào thiên nhiên', 4.9);
INSERT INTO LOAI_HINH VALUES ('DLVH', N'Du lịch văn hóa', N'Tìm hiểu nền văn hóa lịch sử của điểm du lịch', 4.5);
INSERT INTO LOAI_HINH VALUES ('DLXH', N'Du lịch xã hội', N'Hòa nhập, giao lưu, tiếp xúc với xã hội', 4.3);
INSERT INTO LOAI_HINH VALUES ('DLHD', N'Du lịch hoạt động', N'Thách thức, khám phá bản thân', 4.7);
INSERT INTO LOAI_HINH VALUES ('DLGT', N'Du lịch giải trí', N'Nghỉ ngơi, thư giãn, phục hồi sinh khí', 4.5);
INSERT INTO LOAI_HINH VALUES ('DLTT', N'Du lịch thể thao', N'Trải nghiệm hoạt động thể thao thú vị', 4.6);
INSERT INTO LOAI_HINH VALUES ('DLCD', N'Du lịch chuyên đề', N'Đi du lịch cùng mục đích chung', 4.4);
INSERT INTO LOAI_HINH VALUES ('DLTG', N'Du lịch tôn giáo', N'Thỏa mãn nhu cầu tín ngưỡng', 4.5);
INSERT INTO LOAI_HINH VALUES ('DLSK', N'Du lịch sức khỏe', N'Du lịch vì sức khỏe', 4.8);
INSERT INTO LOAI_HINH VALUES ('DLDT', N'Du lịch dân tộc học', N'Tìm hiểu lịch sử, nguồn gốc quê hương', 4.7);
GO


--Nhập liệu cho bảng Hình thức di chuyển:
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHDB', N'Đi bộ', N'Di chuyển đến địa điểm bằng cách đi bộ');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHXD', N'Xe đạp', N'Di chuyển đến địa điểm bằng cách đạp xe');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHXM', N'Xe máy', N'Di chuyển đến địa điểm bằng cách lái xe máy');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHXB', N'Xe bus', N'Di chuyển đến địa điểm bằng cách đón xe bus');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHXK', N'Xe khách', N'Di chuyển đến địa điểm bằng cách đón xe khách');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHTH', N'Tàu hỏa', N'Di chuyển đến địa điểm bằng cách đi tàu hỏa');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHTT', N'Tàu thuyền', N'Di chuyển đến địa điểm bằng cách đi tàu thuyền');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHMB', N'Máy bay', N'Di chuyển đến địa điểm bằng cách đi máy bay');
INSERT INTO HINH_THUC_DI_CHUYEN VALUES ('VHKH', N'Kết hợp', N'Di chuyển đến địa điểm bằng cách kết hợp nhiều hình thức');
GO


--Nhập liệu cho bảng Hướng dẫn viên:
INSERT INTO HUONG_DAN_VIEN VALUES ('TG001', N'Đỗ Văn Hiệp', 'ZL', '2001-08-12', N'Nam', '0848953906', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG002', N'Nguyễn Phúc Ân', 'KZ', '2001-01-01', N'Nam', '0848953901', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG003', N'Nguyễn Văn Đức', N'Đức', '2001-01-01', N'Nam', '0848953902', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG004', N'Jơ Ngoh Hiếu', N'Hiếu JR', '2001-01-01', N'Nam', '0848953903', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG005', N'Zoe', 'Zoe', '2001-08-12', N'Nữ', '0848953904',100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG006', N'Ryu', 'Ryu', '2001-02-14', N'Nữ', '0848953905', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG007', N'Hmề Hmề', N'Chúa Hề', '2001-01-01', N'Nam', '0848953907', 100);
INSERT INTO HUONG_DAN_VIEN VALUES ('TG008', N'Chu Chu', N'Ảo thật đấy', '2001-01-01', N'Nam', '0848953908', 100);
GO


--Nhập dữ liệu cho bảng Địa điểm:
------------Hà Giang------------
INSERT INTO DIA_DIEM VALUES ('HG001', N'Cao nguyên đá Đồng Văn', N'Khu vực địa chất cổ đại', 4.9, 'VHDB');
INSERT INTO DIA_DIEM VALUES ('HG002', N'Phố cổ Đồng Văn', N'Văn hóa, kiến trúc cổ', 4.7, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('HG003', N'Cột cờ Lũng Cú', N'Địa đầu Tổ quốc', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('HG004', N'Thung lũng Sủng Là', N'Thiên đường hoa cỏ vùng cao', 4.8, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('HG005', N'Đèo Mã Pí Lèng', N'Mang dấu vết của sự phát triển của địa tầng trái đất', 4.7, 'VHXM');


------------Đà Nẵng------------
INSERT INTO DIA_DIEM VALUES ('DN001', N'Bà Nà Hills', N'Đường lên tiên cảnh', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('DN002', N'Asian Park', N'Công viên của những kỷ lục', 4.5, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('DN003', N'Bãi Biển Mỹ Khê', N'Thánh nữ vạn người mê', 4.3, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('DN004', N'Cầu Rồng', N'Biểu tượng mới của thành phố Đà Nẵng', 4.6, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('DN005', N'Rạn Nam Ô', N'Thiên đường của đá', 4.8, 'VHTT');


------------Hội An------------
INSERT INTO DIA_DIEM VALUES ('HA001', N'Phố cổ Hội An', N'Viên ngọc nhỏ', 4.9, 'VHDB');
INSERT INTO DIA_DIEM VALUES ('HA002', N'Chợ Hội An', N'Khu du lịch ở Hội An', 4.5, 'VHXD');
INSERT INTO DIA_DIEM VALUES ('HA003', N'Bảo tàng Lịch sử – Văn hoá Hội An', N'Khu du lịch ở Hội An', 4.5, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('HA004', N'Bãi biển An Bàng', N'Top 25 bãi biển đẹp nhất châu Á', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('HA005', N'Làng gốm Thanh Hà', N'Làng nghề truyền thống nổi tiếng ở Hội An', 4.6, 'VHTH');


------------Lý Sơn------------
INSERT INTO DIA_DIEM VALUES ('LS001', N'Núi Thới Lới', N'Ngọn núi cao nhất trên đảo Lý Sơn', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('LS002', N'Đảo Lớn', N'Cù Lao Ré, là trung tâm của Lý Sơn', 4.7, 'VHTT');
INSERT INTO DIA_DIEM VALUES ('LS003', N'Đảo Bé', N'Đảo An Bình', 4.9, 'VHTT');
INSERT INTO DIA_DIEM VALUES ('LS004', N'Cổng Tò Vò', N'Cổng Thiên Đường.', 4.9, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('LS005', N'Hòn Mù Cu', N'Thiên nhiên hoang sơ, tĩnh lặng Lý Sơn', 4.8, 'VHKH');


------------Sa Pa------------
INSERT INTO DIA_DIEM VALUES ('SP001', N'Núi Hàm Rồng', N'Ngọn núi hình đầu rồng Sa Pa', 4.7, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('SP002', N'Bản Cát Cát', N'Ngôi làng cổ đẹp nhất rừng Tây Bắc', 4.8, 'VHXM');
INSERT INTO DIA_DIEM VALUES ('SP003', N'Cổng trời Sa Pa', N'Thiên đường trong mây', 4.9, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('SP004', N'Đèo Ô Quy Hồ', N'Tứ đại đỉnh đèo - Đường lên cổng trời', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('SP005', N'Đỉnh Fansipan', N'Nóc nhà Đông Dương', 4.8, 'VHDB');


------------Hạ Long------------
INSERT INTO DIA_DIEM VALUES ('HL001', N'Vịnh Hạ Long', N'Di sản thiên nhiên của thế giới', 4.9, 'VHMB');
INSERT INTO DIA_DIEM VALUES ('HL002', N'Đảo Tuần Châu', N'“Viên ngọc” của vịnh Hạ Long', 4.7, 'VHTT');
INSERT INTO DIA_DIEM VALUES ('HL003', N'Đảo Bồ Hòn', N'Hòn đảo của những hang động Hạ Long', 4.5, 'VHTT');
INSERT INTO DIA_DIEM VALUES ('HL004', N'Vịnh Lan Hạ', N'Đảo ngọc thiên đường Cát Bà', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('HL005', N'Cù lao Vạn Bội', N'Bãi tắm thuộc vịnh Lan Hạ', 4.7, 'VHKH');


------------Phú Quốc------------
INSERT INTO DIA_DIEM VALUES ('PQ001', N'Thị trấn Dương Đông', N'Trái tim của Phú Quốc', 4.7, 'VHMB');
INSERT INTO DIA_DIEM VALUES ('PQ002', N'Vinpearl Land Phú Quốc', N'Thiên đường giải trí lớn nhất Phú Quốc', 4.5, 'VHXK');
INSERT INTO DIA_DIEM VALUES ('PQ003', N'Hòn Móng Tay Phú Quốc', N'Đảo Robinson', 4.9, 'VHTT');
INSERT INTO DIA_DIEM VALUES ('PQ004', N'Làng chài Hàm Ninh', N'Làng chài cổ một phần của đảo Phú Quốc', 4.6, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('PQ005', N'Nam đảo', N'Địa điểm du lịch Phú Quốc', 4.8, 'VHKH');


------------Vũng Tàu------------
INSERT INTO DIA_DIEM VALUES ('VT001', N'Tượng chúa Giêsu Kito Vua', N'Biểu tượng của thành phố biển Vũng Tàu', 4.5, 'VHDB');
INSERT INTO DIA_DIEM VALUES ('VT002', N'Biển Long Hải', N'Bãi biển du lịch Vũng Tàu', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('VT003', N'Hải đăng Vũng Tàu', N'Ngọn hải đăng cổ xưa nhất Việt Nam và Đông Nam Á', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('VT004', N'Mũi Nghinh Phong', N'Mũi đất vươn dài nhất ở phía Nam của bán đảo Vũng Tàu', 4.7, 'VHKH');
INSERT INTO DIA_DIEM VALUES ('VT005', N'Khu du lịch Suối Tiên', N'Đà Lạt thứ hai Vũng Tàu', 4.8, 'VHKH');
GO

--Nhập liệu cho bảng Tour:
INSERT INTO TOUR VALUES ('TRHG001', N'Tour Du lịch thiên nhiên Hà Giang', 3990000, 'DLTN', 'TG001', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRHG002', N'Tour Du lịch văn hóa Hà Giang', 3990000, 'DLVH', 'TG001', 3, 2, N'Chưa mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRDN001', N'Tour Du lịch giải trí Đà Nẵng', 4990000, 'DLGT', 'TG002', 4, 3, N'Đang mở', 10, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRDN002', N'Tour Du lịch thiên nhiên Đà Nẵng', 3990000, 'DLTN', 'TG002', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRHA001', N'Tour Du lịch văn hóa Hội An', 3990000, 'DLVH', 'TG003', 3, 2, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRHA002', N'Tour Du lịch xã hội Hội An', 3990000, 'DLXH', 'TG003', 3, 2, N'Chưa mở', 10, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRLS001', N'Tour Du lịch thiên nhiên Lý Sơn', 3990000, 'DLTN', 'TG004', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRLS002', N'Tour Du lịch hoạt động Lý Sơn', 3990000, 'DLHD', 'TG004', 4, 3, N'Chưa mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRSP001', N'Tour Du lịch dân tộc học Sa Pa', 3990000, 'DLDT', 'TG005', 3, 2, N'Chưa mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRSP002', N'Tour Du lịch thiên nhiên Sa Pa', 3990000, 'DLTN', 'TG005', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRHL001', N'Tour Du lịch thiên nhiên Hạ Long', 3990000, 'DLTN', 'TG006', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRHL002', N'Tour Du lịch hoạt động Hạ Long', 3990000, 'DLHD', 'TG006', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRPQ001', N'Tour Du lịch thiên nhiên Phú Quốc', 3990000, 'DLTN', 'TG007', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRPQ002', N'Tour Du lịch sức khỏe Phú Quốc', 3990000, 'DLSK', 'TG007', 3, 2, N'Chưa mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRVT001', N'Tour Du lịch thiên nhiên Vũng Tàu', 3990000, 'DLTN', 'TG008', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');
INSERT INTO TOUR VALUES ('TRVT002', N'Tour Du lịch hoạt động Vũng Tàu', 3990000, 'DLHD', 'TG008', 4, 3, N'Đang mở', 12, N'Tp. Hồ Chí Minh');


--Nhập liệu cho bảng Lịch trình:
INSERT INTO LICH_TRINH VALUES ('TRHG001', 'HG001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRHG001', 'HG002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHG001', 'HG003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHG001', 'HG004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHG001', 'HG005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRDN001', 'DN001', '2021-07-10 6:30:00', '2021-07-10 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRDN001', 'DN002', '2021-07-11 7:30:00', '2021-07-11 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN001', 'DN003', '2021-07-11 13:30:00', '2021-07-11 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN001', 'DN004', '2021-07-12 7:30:00', '2021-07-12 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN001', 'DN005', '2021-07-13 6:30:00', '2021-07-13 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRDN002', 'DN001', '2021-07-21 6:30:00', '2021-07-21 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRDN002', 'DN002', '2021-07-22 7:30:00', '2021-07-22 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN002', 'DN003', '2021-07-22 13:30:00', '2021-07-22 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN002', 'DN004', '2021-07-23 7:30:00', '2021-07-23 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRDN002', 'DN005', '2021-07-24 6:30:00', '2021-07-24 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRHA001', 'HA001', '2021-07-15 6:30:00', '2021-07-15 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRHA001', 'HA002', '2021-07-16 7:30:00', '2021-07-16 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHA001', 'HA003', '2021-07-16 13:30:00', '2021-07-16 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHA001', 'HA004', '2021-07-17 7:30:00', '2021-07-17 14:30:00');


INSERT INTO LICH_TRINH VALUES ('TRSP002', 'SP001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRSP002', 'SP002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRSP002', 'SP003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRSP002', 'SP004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRSP002', 'SP005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRLS001', 'LS001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRLS001', 'LS002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRLS001', 'LS003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRLS001', 'LS004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRLS001', 'LS005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRHL001', 'HL001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRHL001', 'HL002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL001', 'HL003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL001', 'HL004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL001', 'HL005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRHL002', 'HL001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRHL002', 'HL002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL002', 'HL003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL002', 'HL004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRHL002', 'HL005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRPQ001', 'PQ001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRPQ001', 'PQ002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRPQ001', 'PQ003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRPQ001', 'PQ004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRPQ001', 'PQ005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRVT001', 'VT001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRVT001', 'VT002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT001', 'VT003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT001', 'VT004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT001', 'VT005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');

INSERT INTO LICH_TRINH VALUES ('TRVT002', 'VT001', '2021-07-06 6:30:00', '2021-07-06 18:30:00' );
INSERT INTO LICH_TRINH VALUES ('TRVT002', 'VT002', '2021-07-07 7:30:00', '2021-07-07 11:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT002', 'VT003', '2021-07-07 13:30:00', '2021-07-07 19:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT002', 'VT004', '2021-07-08 7:30:00', '2021-07-08 18:30:00');
INSERT INTO LICH_TRINH VALUES ('TRVT002', 'VT005', '2021-07-09 6:30:00', '2021-07-09 14:30:00');


--Nhập liệu cho bảng Khách hàng:
INSERT INTO KHACH_HANG VALUES ('CT001', N'Zepp Layy', '7143432', '2001-8-12', N'Nam', N'Đắk Lắk', '0848953906','Zepplayy@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT002', N'Nguyễn Văn A', '7143433', '2001-8-13', N'Nam', N'Lâm Đồng', '0848741311','vana@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT003', N'Nguyễn Thị B', '7143434', '2001-6-18', N'Nữ', N'Hà Nội', '0392234488','thib@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT004', N'Trần Tấn C', '7143435', '2001-7-15', N'Nam', N'TP. Hồ Chí Minh', '0905010203','tanc@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT005', N'Đỗ Thị D', '7143436', '2001-3-12', N'Nữ', N'Đồng Nai', '0366432132','ddo@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT006', N'Phạm Tiến H', '7143437', '2001-12-28', N'Nam', N'Bình Dương', '0853955179','tienh@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT007', N'Hoàng Diễm K', '7143438', '2000-2-14', N'Nữ', N'Bến Tre', '0859635310','dkhoang@gmail.com', N'Sinh Viên');
INSERT INTO KHACH_HANG VALUES ('CT008', N'Đoàn Công T', '7143439', '2001-1-3', N'Nam', N'Kiên Giang', '0707993264','congt@gmail.com', N'Sinh Viên');
GO


ALTER TABLE TOUR
ADD HINH_TOUR varchar(100)
GO

UPDATE TOUR
SET HINH_TOUR = 'images/TRVT002.jpg' WHERE Ma_Tour = 'TRVT002'
GO

CREATE TABLE TAI_KHOAN
(
	Tai_khoan varchar(100) primary key,
	Matkhau nvarchar(100),
	Email varchar(100)
)
GO

select * from TAI_KHOAN
