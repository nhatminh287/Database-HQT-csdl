﻿--Cập nhật giỏ hàng
create PROC CapNhatGioHang
	@makh char(50), @idmon  char(50), @soluong int
AS
BEGIN TRANSACTION
	begin try
	--Kiem tra ton tai tai khoan
		IF EXISTS (SELECT * FROM ChiTietGioHang WHERE KhachHangID = @makh and MonID = @idmon)
			BEGIN
				update ChiTietGioHang set SoLuong = SoLuong + @soluong where  KhachHangID = @makh and MonID = @idmon			
				commit
				RETURN 1
			END
		ELSE
			begin 
				insert into ChiTietGioHang values (@makh , @idmon, @soluong)
				commit
				return 1
			end
		end try
		begin catch
			print N'Đã xảy ra lỗi!'
			rollback transaction
			return 0
		end catch
		
go

--Them Chi tiết đơn hàng
CREATE PROC ThemChiTietDonHang
	@idmon char(50), @soluong int, @gia int 
AS
BEGIN TRANSACTION
	begin try
	--
		declare @idDonHang int
		set @idDonHang = (select max(DonHangID) from DonHang)
		insert into ChiTietDonHang(MonID, DonHangID, SoLuong, GiaBan) 
		values (@idmon, @idDonHang, @soluong, @gia)
		commit
		return 1
	end try
		begin catch
			print N'Đã xảy ra lỗi!'
			rollback transaction
			return 0
		end catch
		
go
