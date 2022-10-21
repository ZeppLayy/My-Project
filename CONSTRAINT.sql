USE DU_LICH
GO

-------------TRIGGER & CONSTRAINT--------------
--1. Giới hạn điểm đánh giá loại hình không được lớn hơn 5:
CREATE TRIGGER LIM_DANH_GIA_LOAI_HINH ON LOAI_HINH
FOR INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
	Select * from inserted where Danh_Gia > 5
	PRINT N'Điểm đánh giá không được lớn hơn 5'
	ROLLBACK TRAN
END
GO

--2. Giới hạn điểm đánh giá địa điểm không được lớn hơn 5:
CREATE TRIGGER LIM_DANH_GIA_DIA_DIEM ON DIA_DIEM
FOR INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
	Select * from inserted where Danh_Gia > 5
	PRINT N'Điểm đánh giá không được lớn hơn 5'
	ROLLBACK TRAN
END
GO


--3. Hợp lý số lượng vé được mua với số lượng nhận của Tour:
--Trigger cập nhập số lượng còn trống sau khi có khách đặt vé:
CREATE TRIGGER TRG_DANG_KO_TOUR_1 ON DANG_KI_TOUR 
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON
	UPDATE TOUR
	SET So_Luong_Nhan = So_Luong_Nhan - (
	SELECT So_luong_ve FROM inserted AS I
	WHERE I.Ma_tour = T.Ma_Tour)
	FROM TOUR AS T
		JOIN inserted ON T.Ma_Tour = inserted.Ma_tour
END
GO

--Constraint số lượng nhận không được < 0:
---> Số lượng vé sẽ không thể lớn hơn số lượng nhận.
ALTER TABLE dbo.TOUR
ADD CONSTRAINT check_TOUR
CHECK (So_Luong_Nhan >=0)
GO


--4. Khách hàng chỉ có thể đăng ký được các tour đang mở:
ALTER TRIGGER TRG_KHACH_HANG_DANG_KY_TOUR ON DANG_KI_TOUR
FOR INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Status nvarchar(20)
	SELECT @Status = T.Trang_Thai FROM inserted AS I
	LEFT JOIN TOUR AS T ON I.Ma_tour = T.Ma_Tour
	IF @Status = N'Chưa mở'
	BEGIN
		PRINT N'Tour đã đóng hoặc chưa mở đăng ký'
		ROLLBACK
	END
END
GO


--5. Cập nhập trạng thái tour khi số lượng nhận = 0:
CREATE TRIGGER ABC ON TOUR
FOR INSERT, UPDATE
AS
BEGIN
	UPDATE TOUR
	SET Trang_Thai = N'Đã đóng'
	WHERE So_Luong_Nhan = 0
END
GO


--6. Rằng buộc Tour chỉ có 3 trạng thái mở, chưa mở và đóng:
ALTER TABLE TOUR
ADD CONSTRAINT check_Status 
CHECK (Trang_thai in (N'Đang mở', N'Đã đóng', N'Chưa mở', null))
GO


--7. Tuổi của khách hàng không thể lớn hơn 150 và nhỏ hơn 0:
CREATE TRIGGER TUOI_KHACH_HANG ON KHACH_HANG
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @TUOI int
	SELECT @TUOI = (YEAR(GETDATE()) - YEAR(NGAY_SINH)) FROM KHACH_HANG
	IF @TUOI < 0 OR @TUOI > 150
	BEGIN
		PRINT N'Ngày sinh không hợp lệ'
		ROLLBACK
	END
END
GO


--8. Tuổi của hướng dẫn viên không thể lớn hơn 60 và nhỏ hơn 22:
CREATE TRIGGER TUOI_HDV ON HUONG_DAN_VIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @TUOI int
	SELECT @TUOI = (YEAR(GETDATE()) - YEAR(NGAY_SINH)) FROM HUONG_DAN_VIEN
	IF @TUOI < 18 OR @TUOI > 60
	BEGIN
		PRINT N'Ngày sinh không hợp lệ'
		ROLLBACK
	END
END
GO


--9. Tên tour không được trùng nhau:
ALTER TABLE TOUR
ADD UNIQUE (TEN_TOUR)
GO


--10. Tên loại hình không được trùng nhau:
ALTER TABLE LOAI_HINH
ADD UNIQUE (TEN_LOAI_HINH)
GO


--11. Tên địa điệm không được trùng nhau:
ALTER TABLE DIA_DIEM
ADD UNIQUE (TEN_DIA_DIEM)
GO


--12. Tên hình thức di chuyển không được trùng nhau:
ALTER TABLE HINH_THUC_DI_CHUYEN
ADD UNIQUE (TEN_HTDC)
GO


--12. Số ngày và số đêm phải bằng nhau hoặc số ngày lớn hơn số đêm = 1:
ALTER TABLE TOUR
ADD CONSTRAINT check_Ngay_dem
CHECK (So_ngay - So_dem <= 1 AND So_ngay - So_dem >=0)
GO


--13. Điểm số của các hướng dẫn viên không được > 100 và < 0:
ALTER TABLE HUONG_DAN_VIEN
ADD CONSTRAINT check_diem_so_HDV
CHECK (DIEM_SO >=0 AND DIEM_SO <=100)
GO

 
--14. Điểm đánh giá địa điểm với loại hình không được < 0:
ALTER TABLE DIA_DIEM
ADD CONSTRAINT check_danh_gia_DD
CHECK (Danh_gia >= 0)
GO

ALTER TABLE LOAI_HINH
ADD CONSTRAINT check_danh_gia_LH
CHECK (Danh_gia >= 0)
GO


--15. Tự động cập nhập trạng thái Tour khi thời gian khởi hành, nghỉ ngơi là quá khứ
CREATE TRIGGER THOI_GIAN_LICH_TRINH ON LICH_TRINH
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @MaTour varchar(10)
	SELECT @MaTour = Ma_Tour FROM inserted
	IF EXISTS (
		SELECT Thoi_gian_khoi_hanh FROM inserted AS I
		LEFT JOIN TOUR AS T ON T.Ma_Tour = I.Ma_Tour
		WHERE I.Thoi_gian_khoi_hanh < GETDATE() AND I.Thoi_gian_nghi_ngoi < GETDATE())
	BEGIN
		UPDATE TOUR
		SET Trang_Thai = N'Đã đóng' WHERE Ma_Tour = @MaTour
	END
END


--16. CMND/CCCD của khách hàng là không trùng nhau
ALTER TABLE KHACH_HANG
ADD UNIQUE (CMND_CCCD)
GO


--17. Giới tính của những thực thể là người:
ALTER TABLE KHACH_HANG
ADD CONSTRAINT check_SEX
CHECK (GIOI_TINH in (N'Nam', N'Nữ', null))
GO

ALTER TABLE HUONG_DAN_VIEN
ADD CONSTRAINT check_SEX2
CHECK (GIOI_TINH in (N'Nam', N'Nữ', null))
GO


--18. Nick name của hướng dẫn viên không được trùng nhau:
ALTER TABLE HUONG_DAN_VIEN
ADD UNIQUE (NICK_NAME)
GO


--19. Số lượng vé đăng ký không được nhỏ hơn 0:
ALTER TABLE DANG_KI_TOUR
ADD CONSTRAINT check_SLV
CHECK (So_luong_ve >= 0)
GO


--20. Hủy đăng ký sẽ cập nhập lại số lượng nhận:
CREATE TRIGGER HUY_DANG_KI ON DANG_KI_TOUR FOR DELETE AS 
BEGIN
	SET NOCOUNT ON
	DECLARE @MaTour varchar(10)
	SELECT @MaTour = Ma_Tour FROM deleted
	UPDATE TOUR
	SET So_Luong_Nhan = So_Luong_Nhan + (SELECT So_luong_ve FROM deleted WHERE Ma_Tour = TOUR.Ma_Tour)
		FROM TOUR 
		JOIN deleted ON TOUR.Ma_Tour = deleted.Ma_tour
	UPDATE TOUR
	SET TRANG_THAI = N'Đang mở' WHERE TRANG_THAI = N'Đã đóng' AND Ma_Tour = @MaTour
END
GO

--21. Số điện thoại của khách hàng và hướng dẫn viên:
ALTER TABLE KHACH_HANG
ADD UNIQUE (SDT)
GO

ALTER TABLE HUONG_DAN_VIEN
ADD UNIQUE (SDT)
GO


--22. 

SELECT * FROM TOUR