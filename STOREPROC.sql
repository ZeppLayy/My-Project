USE DU_LICH
GO

-------------STORE PROCEDURE--------------
--1. Hiển thị thông tin của một Tour bất kỳ:
CREATE PROCEDURE THONG_TIN_TOUR
@MaTour varchar(10)
AS
BEGIN
	SELECT T.*, LH.Ten_Loai_Hinh, Ten_HDV  FROM TOUR AS T
	LEFT JOIN LOAI_HINH AS LH ON T.Ma_Loai_Hinh = LH.Ma_Loai_Hinh
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
	WHERE Ma_Tour = @MaTour
END
GO


--2. Lọc Tour theo loại hình, số ngày, số đêm:
CREATE PROCEDURE LOC_TOUR
@MaLH varchar(10),
@Ngay int,
@Dem int
AS
BEGIN
	SELECT * 
	FROM (SELECT T.*, LH.Ten_Loai_Hinh, Ten_HDV  FROM TOUR AS T
	LEFT JOIN LOAI_HINH AS LH ON T.Ma_Loai_Hinh = LH.Ma_Loai_Hinh
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV) AS Z
	WHERE  Z.Ma_Loai_Hinh = @MaLH AND Z.So_ngay = @Ngay
	AND Z.So_dem = @Dem
END
GO


--3. Xem lịch trình của một Tour bất kỳ:
CREATE PROCEDURE THONG_TIN_LICH_TRINH_TOUR
@MaTour varchar(10)
AS
BEGIN
	Select  T.Ten_Tour, HDV.Ten_HDV, DD.Ten_Dia_Diem, LT.Thoi_gian_khoi_hanh, LT.Thoi_gian_nghi_ngoi from TOUR as T
	LEFT JOIN LICH_TRINH as LT ON T.Ma_Tour = LT.Ma_Tour
	LEFT JOIN DIA_DIEM as DD ON LT.Ma_DD = DD.Ma_DD
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
	WHERE T.Ma_Tour = @MaTour 
END
GO

--4. Thêm Tour vào cơ sở dữ liệu:
CREATE PROCEDURE THEM_TOUR
	@MaTour varchar(10),
	@TenTour nvarchar(100),
	@GiaTour int,
	@MaLoaiHinh varchar(10),
	@MaHDV varchar(10),
	@Songay int,
	@Sodem int,
	@TrangThai nvarchar(20),
	@SoLuongNhan int,
	@Noikhoihanh nvarchar(50)
AS 
BEGIN 
INSERT INTO TOUR
VALUES (@MaTour, @TenTour, @GiaTour, @MaLoaiHinh, @MaHDV, @Songay, @Sodem, @TrangThai, @SoLuongNhan, @Noikhoihanh)
END
GO


--5. Cập nhập thông tin Tour:
CREATE PROCEDURE CAP_NHAP_TOUR
	@MaTour varchar(10),
	@TenTour nvarchar(100),
	@GiaTour int,
	@MaLoaiHinh varchar(10),
	@MaHDV varchar(10),
	@Songay int,
	@Sodem int,
	@TrangThai nvarchar(20),
	@SoLuongNhan int,
	@Noikhoihanh nvarchar(50)
AS 
BEGIN
UPDATE TOUR
SET Ten_Tour = @TenTour,
	Gia_Tour = @GiaTour,
	Ma_Loai_Hinh = @MaLoaiHinh,
	Ma_HDV = @MaHDV,
	So_ngay = @Songay,
	So_dem = @Sodem,
	Trang_Thai = @TrangThai,
	So_Luong_Nhan = @SoLuongNhan,
	Noi_khoi_hanh = @Noikhoihanh
WHERE Ma_Tour = @MaTour
END
GO


--6. Xóa Tour:
CREATE PROCEDURE XOA_TOUR
@ID varchar(10)
AS
BEGIN
	DELETE FROM TOUR
	WHERE Ma_Tour = @ID
END
GO


--7. Hiển thị thông tin của một địa điểm bất kỳ:
CREATE PROCEDURE THONG_TIN_DIA_DIEM2
@MaDD varchar(10)
AS
BEGIN
	SELECT DD.*, DC.Ten_HTDC, DC.Mo_ta FROM DIA_DIEM AS DD
	LEFT JOIN HINH_THUC_DI_CHUYEN AS DC
	ON DD.Ma_HTDC = DC.Ma_HTDC
	WHERE Ma_DD = @MaDD
END
GO


--8. Hiển thị danh mục Tour:
CREATE PROCEDURE DANH_MUC_TOUR
AS
BEGIN
	SELECT T.*, LH.Ten_Loai_Hinh, Ten_HDV  FROM TOUR AS T
	LEFT JOIN LOAI_HINH AS LH ON T.Ma_Loai_Hinh = LH.Ma_Loai_Hinh
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
END
GO


--9. Tìm thông tin hướng dẫn viên của một Tour bất kì:
CREATE PROCEDURE THONG_TIN_HUONG_DAN_VIEN_TOUR
@MaTour varchar(10)
AS
BEGIN
	SELECT HDV.* FROM TOUR AS T
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
	WHERE T.Ma_Tour = @MaTour
END
GO


--10. Tìm thông tin lịch trình của địa điểm bất kì có trong tour:
CREATE PROCEDURE THONG_TIN_LICH_TRINH_DD
@MaKH varchar(10)
AS
BEGIN
	SELECT * FROM KHACH_HANG
	WHERE Ma_Khach_Hang = @MaKH
END
GO
 

--11. Tìm thông tin các khách hàng đã đăng ký Tour:
CREATE PROCEDURE THONG_TIN_KHACH_HANG_TOUR
@MaTour varchar(10)
AS
BEGIN
	SELECT KH.*, DK.Ma_dang_ky, DK.So_luong_ve FROM TOUR AS T
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	LEFT JOIN KHACH_HANG AS KH ON DK.Ma_khach_hang = KH.Ma_Khach_Hang
	WHERE T.Ma_Tour = @MaTour
END
GO


--12. Phân công Tour cho hướng dẫn viên:
CREATE PROCEDURE PHAN_CONG_TOUR
@MaTour varchar(10),
@MaHDV varchar(10)
AS
BEGIN
UPDATE TOUR
SET Ma_HDV = @MaHDV
WHERE Ma_Tour = @MaTour
END
GO

--13. Xem điểm đánh giá trung bình của một Tour:
CREATE PROCEDURE DANH_GIA_TB_TOUR
@MaTour varchar(10)
AS
BEGIN

/*SELECT T.Ten_Tour, AVG(DD.Danh_Gia) AS N'Điểm đánh giá trung bình' FROM TOUR AS T
LEFT JOIN LICH_TRINH AS LT ON T.Ma_Tour = LT.Ma_Tour
LEFT JOIN DIA_DIEM AS DD ON LT.Ma_DD = DD.Ma_DD
WHERE T.Ma_Tour = @MaTour
GROUP BY T.Ten_Tour*/

	DECLARE @Ten nvarchar(100)
	DECLARE @AVG float
	SELECT @Ten = T.Ten_Tour  FROM TOUR AS T
	WHERE Ma_Tour = @MaTour
	SELECT @AVG = AVG(DD.Danh_Gia) FROM TOUR AS T
	LEFT JOIN LICH_TRINH AS LT ON T.Ma_Tour = LT.Ma_Tour
	LEFT JOIN DIA_DIEM AS DD ON LT.Ma_DD = DD.Ma_DD
	WHERE T.Ma_Tour = @MaTour

	PRINT @Ten
	PRINT N'Điểm đánh giá trung bình: ' +  CONVERT(nvarchar(10), @AVG)
	PRINT '_____________UwU_____________'
END
GO


--14. Xuất ra thông tin tên hướng dẫn viên cùng với số lượng Tour du lịch đang được phân công và trạng thái:
CREATE FUNCTION HDV
(	
	@MaHDV varchar(10),
	@Status nvarchar(20)
)
RETURNs int
AS
BEGIN
	DECLARE @KQ int;
	SELECT @KQ = COUNT(HDV.MA_HDV) FROM TOUR AS T
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
	WHERE HDV.Ma_HDV = @MaHDV AND T.Trang_Thai = @Status
	RETURN @KQ
END
GO

CREATE PROCEDURE SL_TOUR_HUONG_DAN_VIEN
	@MaHDV varchar(10),
	@Status1 nvarchar(20)

AS
BEGIN
	DECLARE @KQ1 int
	DECLARE @KQ2 int
	DECLARE @Ten nvarchar(100)
	DECLARE @TOUR nvarchar(100)
		DECLARE @TOUR1 nvarchar(100)

	SELECT @TOUR = HD.Ten_HDV FROM TOUR AS T
	LEFT JOIN HUONG_DAN_VIEN AS HD ON T.Ma_HDV = HD.Ma_HDV
	SELECT @Ten = Ten_HDV FROM HUONG_DAN_VIEN 
	WHERE Ma_HDV = @MaHDV
	SELECT @KQ1 = dbo.HDV (@MaHDV, @Status1)
	SELECT @KQ2 = COUNT(HDV.MA_HDV) FROM TOUR AS T
	LEFT JOIN HUONG_DAN_VIEN AS HDV ON T.Ma_HDV = HDV.Ma_HDV
	WHERE HDV.Ma_HDV = @MaHDV
	
	PRINT N'Tên hướng dẫn viên: ' + @Ten
	PRINT N'Tour đã nhận: ' + CONVERT(nvarchar(10), @KQ2)
	
	BEGIN
	IF @Status1 = N'Đang mở'
		PRINT '			' + N'Trạng thái đang mở: ' +  CONVERT(nvarchar(10), @KQ1)
	END

	BEGIN
	IF @Status1 = N'Đã đóng'
		PRINT '			' + N'Trạng thái đã đóng: ' +  CONVERT(nvarchar(10), @KQ1)
	END

	BEGIN
	IF @Status1 = N'Chưa mở'
		PRINT '			' + N'Trạng thái chưa mở: ' +  CONVERT(nvarchar(10), @KQ1)
	END
END
GO


--15. Hiển thị thông tin thanh toán của một đơn đăng ký:
CREATE PROCEDURE THONG_TIN_THANH_TOAN
	@MaDK varchar(10)
AS
BEGIN
	DECLARE @MaTour varchar(10)
	DECLARE @TenTour nvarchar(100)
	DECLARE @MaKH varchar(10)
	DECLARE @TenKH nvarchar(100)
	DECLARE @Gia int
	DECLARE @DonGia int
	DECLARE @SoLuongVe int

	SELECT @MaTour = T.Ma_Tour FROM TOUR AS T 
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	WHERE DK.Ma_dang_ky = @MaDK

	SELECT @TenTour = T.Ten_Tour FROM TOUR AS T 
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	WHERE DK.Ma_dang_ky = @MaDK

	SELECT @Gia = T.Gia_Tour * DK.So_luong_ve FROM TOUR AS T 
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	WHERE DK.Ma_dang_ky = @MaDK

	SELECT @DonGia = T.Gia_Tour FROM TOUR AS T 
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	WHERE DK.Ma_dang_ky = @MaDK

	SELECT @SoLuongVe = DK.So_luong_ve FROM TOUR AS T 
	LEFT JOIN DANG_KI_TOUR AS DK ON T.Ma_Tour = DK.Ma_tour
	WHERE DK.Ma_dang_ky = @MaDK
	
	SELECT @MaKH = KH.Ma_khach_hang FROM KHACH_HANG AS KH
	LEFT JOIN DANG_KI_TOUR AS DK ON DK.Ma_khach_hang = KH.Ma_Khach_Hang
	WHERE DK.Ma_dang_ky = @MaDK

	SELECT @TenKH = KH.Ten_Khach_Hang FROM KHACH_HANG AS KH
	LEFT JOIN DANG_KI_TOUR AS DK ON DK.Ma_khach_hang = KH.Ma_Khach_Hang
	WHERE DK.Ma_dang_ky = @MaDK	

	PRINT N'Thông tin thanh toán của đơn đăng ký số: ' + CONVERT(nvarchar(10), @MaDK)
	PRINT '----------------------------------------'
	PRINT N'A. Khách hàng'
	PRINT '		' + N'1. Mã khách hàng: ' +  CONVERT(nvarchar(10), @MaKH)
	PRINT '		' + N'2. Tên khách hàng: ' +  @TenKH
	PRINT '----------------------------------------'
	PRINT N'B. Tour đăng ký'
	PRINT '		' + N'1. Mã TOUR: ' +  CONVERT(nvarchar(10), @MaTour)
	PRINT '		' + N'2. Tên TOUR: ' +  @TenTour
	PRINT '		' + N'3. Đơn giá: ' + CONVERT(nvarchar(10), @DonGia) + N'VNĐ'
	PRINT '		' + N'4. Số lượng vé đăng ký: ' + CONVERT(nvarchar(10), @SoLuongVe)
	PRINT '----------------------------------------'
	PRINT N'Thành tiền: ' + CONVERT(nvarchar(10), @Gia) + N'VNĐ'
END
GO


--16. Xem thông tin của một khách hàng bất kì:
CREATE PROCEDURE XEM_THONG_TIN_KHACH_HANG
@MaKH varchar(10)
AS
BEGIN
	SELECT * FROM KHACH_HANG WHERE Ma_Khach_Hang = @MaKH
END
GO


--17.Xem danh mục khách hàng:
CREATE PROCEDURE DANH_MUC_KHACH_HANG
AS
BEGIN
	SELECT * FROM KHACH_HANG
END
GO


--18. Thêm thông tin khách hàng vào CSDL:
CREATE PROCEDURE THEM_KHACH_HANG
	@MaKH varchar(10),
	@Ten nvarchar(100),
	@CMND varchar(20),
	@NgaySinh date,
	@GioiTinh nvarchar(10),
	@DiaChi nvarchar(100),
	@SDT varchar(11),
	@Email varchar(20),
	@Nghe nvarchar(20)

AS 
BEGIN 
INSERT INTO KHACH_HANG
VALUES (@MaKH ,@Ten ,@CMND ,@NgaySinh ,@GioiTinh ,@DiaChi ,@SDT ,@Email ,@Nghe)
END
GO


--19. Cập nhập thông tin khách hàng:
CREATE PROCEDURE CAP_NHAP_KHACH_HANG
	@MaKH varchar(10),
	@Ten nvarchar(100),
	@CMND varchar(20),
	@NgaySinh date,
	@GioiTinh nvarchar(10),
	@DiaChi nvarchar(100),
	@SDT varchar(11),
	@Email varchar(20),
	@Nghe nvarchar(20)

AS 
BEGIN 
UPDATE KHACH_HANG
SET Ten_Khach_Hang = @Ten,
	CMND_CCCD = @CMND,
	Ngay_Sinh = @NgaySinh,
	Gioi_Tinh = @GioiTinh,
	Dia_Chi = @DiaChi,
	SDT = @SDT,
	Email = @Email,
	Nghe_Nghiep = @Nghe
WHERE Ma_Khach_Hang = @MaKH
END
GO


--20. Xóa khách hàng:
CREATE PROCEDURE XOA_KHACH_HANG
@MaKH varchar(10)
AS
BEGIN
	DELETE FROM KHACH_HANG
	WHERE Ma_Khach_Hang = @MaKH
END
GO


--21. Xem thông tin của một địa điểm bất kỳ:
CREATE PROCEDURE THONG_TIN_DIA_DIEM
@MaDD varchar(10)
AS
BEGIN
	SELECT * FROM DIA_DIEM WHERE Ma_DD = @MaDD
END
GO


--22. Xem danh mục địa điểm:
CREATE PROCEDURE DANH_MUC_DIA_DIEM
AS
BEGIN
	SELECT * FROM DIA_DIEM
END
GO


--23. Thêm địa điểm vào cơ sở dữ liệu:
CREATE PROCEDURE THEM_DIA_DIEM
@MaDD varchar(10),
@Ten nvarchar(100),
@NoiBat nvarchar(100),
@DanhGia int,
@MaHTDC varchar(10)
AS
BEGIN
	INSERT INTO DIA_DIEM VALUES(@MaDD, @Ten, @NoiBat, @DanhGia, @MaHTDC)
END
GO


--24. Cập nhập thông tin địa điểm:
CREATE PROCEDURE CAP_NHAP_DIA_DIEM
	@MaDD varchar(10),
	@Ten nvarchar(100),
	@NoiBat nvarchar(100),
	@DanhGia int,
	@MaHTDC varchar(10)
AS 
BEGIN 
UPDATE DIA_DIEM
SET Ten_dia_diem = @Ten,
	Diem_noi_bat = @NoiBat,
	Danh_gia = @DanhGia,
	Ma_HTDC = @MaHTDC
WHERE Ma_DD = @MaDD
END
GO


--25. Xóa địa điểm:
CREATE PROCEDURE XOA_DIA_DIEM
@MaDD varchar(10)
AS
BEGIN
	DELETE FROM DIA_DIEM
	WHERE Ma_DD = @MaDD
END
GO


--26. Xem thông tin của một hình thức di chuyển bất kì:
CREATE PROCEDURE THONG_TIN_HTDC
@MaHTDC varchar(10)
AS
BEGIN
	SELECT * FROM HINH_THUC_DI_CHUYEN WHERE Ma_HTDC = @MaHTDC
END
GO


--27. Xem danh mục hình thức di chuyển:
CREATE PROCEDURE DANH_MUC_HTDC
AS
BEGIN
	SELECT * FROM HINH_THUC_DI_CHUYEN
END
GO


--28. Thêm hình thức di chuyển:
CREATE PROCEDURE THEM_HTDC
	@MaHT varchar(10),
	@Ten nvarchar(100),
	@Mota nvarchar(100)
AS
BEGIN
	INSERT INTO HINH_THUC_DI_CHUYEN VALUES (@MaHT, @Ten, @Mota)
END
GO


--29. Cập nhập thông tin hình thức di chuyển:
CREATE PROCEDURE CAP_NHAP_HTDC
	@MaHT varchar(10),
	@Ten nvarchar(100),
	@Mota nvarchar(100)
AS
BEGIN
	UPDATE HINH_THUC_DI_CHUYEN
	SET Ten_HTDC = @Ten,
		Mo_ta = @Mota
END
GO


--30. Xóa hình thức di chuyển:
CREATE PROCEDURE XOA_HTDC
	@MaHT varchar(10)
AS
BEGIN
	DELETE FROM HINH_THUC_DI_CHUYEN WHERE Ma_HTDC = @MaHT
END
GO


--31. Xem danh mục lịch trình:
CREATE PROCEDURE DANH_MUC_LICH_TRINH
AS
BEGIN
	SELECT * FROM LICH_TRINH
END
GO


--32. Thêm lịch trình:
CREATE PROCEDURE THEM_LICH_TRINH
	@MaTour varchar(10),
	@MaDD varchar(10),
	@Khoihanh datetime,
	@Nghingoi datetime
AS
BEGIN
	INSERT INTO LICH_TRINH VALUES(@MaTour, @MaDD, @Khoihanh, @Nghingoi)
END
GO


--33. Cập nhập lịch trình:
CREATE PROCEDURE CAP_NHAP_LICH_TRINH
	@MaTour varchar(10),
	@MaDD varchar(10),
	@Khoihanh datetime,
	@Nghingoi datetime
AS
BEGIN
	UPDATE LICH_TRINH
	SET 
		Thoi_gian_khoi_hanh = @Khoihanh,
		Thoi_gian_nghi_ngoi = @Nghingoi
	WHERE Ma_Tour = @MaTour AND Ma_DD = @MaDD
END
GO


--34. Xóa lịch trình:
CREATE PROCEDURE XOA_LICH_TRINH
	@MaTour varchar(10),
	@MaDD varchar(10)
AS
BEGIN
	DELETE FROM LICH_TRINH WHERE Ma_Tour = @MaTour AND Ma_DD = @MaDD
END


--35. Xem thông tin loại hình bất kì:
CREATE PROCEDURE THONG_TIN_LOAI_HINH
@MaLH varchar(10)
AS
BEGIN
	SELECT * FROM LOAI_HINH WHERE Ma_Loai_Hinh = @MaLH
END
GO


--36. Danh mục loại hình:
CREATE PROCEDURE DANH_MUC_LOAI_HINH
AS
BEGIN
	SELECT * FROM LOAI_HINH
END
GO


--37. Thêm loại hình:
CREATE PROCEDURE THEM_LOAI_HINH
	@MaLH varchar(10),
	@TenLH nvarchar(100),
	@Dacdiem nvarchar(100),
	@Danhgia int
AS
BEGIN
	INSERT INTO LOAI_HINH VALUES (@MaLH, @TenLH, @Dacdiem, @Danhgia)
END
GO


--38. Cập nhập thông tin loại hình:
CREATE PROCEDURE CAP_NHAP_LOAI
	@MaLH varchar(10),
	@TenLH nvarchar(100),
	@Dacdiem nvarchar(100),
	@Danhgia int
AS
BEGIN
	UPDATE LOAI_HINH
	SET Ten_loai_hinh = @TenLH,
		Dac_Diem = @Dacdiem,
		Danh_Gia = @Danhgia
	WHERE Ma_loai_hinh = @MaLH
END
GO


--39. Xóa loại hình:
CREATE PROCEDURE XOA_LOAI_HINH
@MaLH varchar(10)
AS
BEGIN
	DELETE FROM LOAI_HINH WHERE Ma_loai_hinh = @MaLH
END
GO


--40. Xem thông tin của một hướng dẫn viên bất kì:
CREATE PROCEDURE THONG_TIN_HUONG_DAN_VIEN
@MaHDV varchar(10)
AS
BEGIN
	SELECT * FROM HUONG_DAN_VIEN WHERE Ma_HDV = @MaHDV
END
GO


--41. Danh mục hướng dẫn viên:
CREATE PROCEDURE DANH_MUC_HUONG_DAN_VIEN
AS
BEGIN
	SELECT * FROM HUONG_DAN_VIEN
END
GO


--42. Thêm hướng dẫn viên:
CREATE PROCEDURE THEM_HUONG_DAN_VIEN
	@MaHDV varchar(10),
	@Ten nvarchar(100),
	@Nick_name nvarchar(100),
	@Ngaysinh date,
	@GioiTinh nvarchar(20),
	@SDT char(11),
	@Diem int
AS
BEGIN
	INSERT INTO HUONG_DAN_VIEN
	VALUES (@MaHDV, @Ten, @Nick_name, @Ngaysinh, @GioiTinh, @SDT, @Diem)
END
GO


--43. Cập nhập thông tin hướng dẫn viên:
CREATE PROCEDURE CAP_NHAP_HUONG_DAN_VIEN
	@MaHDV varchar(10),
	@Ten nvarchar(100),
	@Nick_name nvarchar(100),
	@Ngaysinh date,
	@GioiTinh nvarchar(20),
	@SDT char(11),
	@Diem int
AS
BEGIN
	UPDATE HUONG_DAN_VIEN
	SET Ten_HDV = @Ten,
		Nick_name = @Nick_name,
		Ngay_sinh = @Ngaysinh,
		Gioi_tinh = @GioiTinh,
		SDT = @SDT,
		Diem_so = @Diem
	WHERE Ma_HDV = @MaHDV
END
GO


--44. Xóa hướng dẫn viên:
CREATE PROCEDURE XOA_HUONG_DAN_VIEN
@MaHDV varchar(10)
AS
BEGIN
	DELETE FROM HUONG_DAN_VIEN WHERE Ma_HDV = @MaHDV
END
GO


--45. Xem thông tin của một đăng ký bất kì:
CREATE PROCEDURE THONG_TIN_DANG_KI
@MaDK varchar(10)
AS
BEGIN
	SELECT * FROM DANG_KI_TOUR WHERE Ma_dang_ky = @MaDK
END
GO


--46. Danh mục đăng ký:
CREATE PROCEDURE DANH_MUC_DANG_KI
AS
BEGIN
	SELECT * FROM DANG_KI_TOUR
END
GO


--47. Thêm thông tin đăng ký:
CREATE PROCEDURE THEM_THONG_TIN_DANG_KI
	@MaDK varchar(10),
	@MaTour varchar(10),
	@MaKH varchar(10),
	@SLV int
AS
BEGIN
	INSERT INTO DANG_KI_TOUR VALUES (@MaDK, @MaTour, @MaKH, @SLV)
END
GO


--48. Cập nhập thông tin đăng ký:
CREATE PROCEDURE CAP_NHAP_THONG_TIN_DANG_KI
	@MaDK varchar(10),
	@MaTour varchar(10),
	@MaKH varchar(10),
	@SLV int
AS
BEGIN
	UPDATE DANG_KI_TOUR
	SET Ma_tour = @MaTour,
		Ma_khach_hang = @MaKH,
		So_luong_ve = @SLV
	WHERE Ma_dang_ky = @MaDK
END
GO


--49. Xóa thông tin đăng ký:
CREATE PROCEDURE XOA_DANG_KI
	@MaDK varchar(10)
AS
BEGIN
	DELETE FROM DANG_KI_TOUR WHERE Ma_dang_ky = @MaDK
END
GO
