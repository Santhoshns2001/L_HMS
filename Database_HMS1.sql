create table Investigation(
Invest_Id int primary key identity(1,1),
Investigation_Name nvarchar(150) not null,
Fees decimal(6,2) not null);

drop table Investigation
drop table Hospital_Bill

select * from investigation
select * from Hospital_Bill

insert into Investigation(Investigation_Name,Fees) values
('',0),
('diabetics', 120),
('Fever', 400),
('Acidity', 500),
('headache', 600),
('Eye Test',1000);


create table Hospital_Bill
(
Bill_No int primary key not null,
Bill_Date date not null,
PatientName nvarchar(150) not null,
Gender varchar(50) check (Gender='Male' or Gender='Female'),
DOB date not null,
Address nvarchar(max),
Email_Id varchar(100),
Mobile_No varchar(10) check (Mobile_No like '[6-9]%' and len(Mobile_No) = 10),
)

--drop table Hospital_Bill
select * from Hospital_Bill

create or alter proc usp_InsertBill
(
@Bill_No int,
@Bill_Date date,
@PatientName nvarchar(150),
@Gender varchar(50),
@DOB date,
@Address nvarchar(max),
@Email_Id varchar(100),
@Mobile_No varchar(10)
)
as
begin
  SET NOCOUNT ON;
    BEGIN TRY
        IF @Bill_No IS NULL OR @Bill_Date IS NULL OR @PatientName IS NULL OR 
           @Gender IS NULL OR (@Gender != 'Male' AND @Gender != 'Female') OR 
           @DOB IS NULL OR @Mobile_No IS NULL OR 
           (@Mobile_No NOT LIKE '[6-9]%' OR LEN(@Mobile_No) != 10)
        BEGIN
            RAISERROR ('All required fields must be provided and constraints must be satisfied.', 16, 1);
            RETURN;
        END

		if not exists(select 1 from Hospital_Bill where Bill_No = @Bill_No)
		begin
			INSERT INTO Hospital_Bill (Bill_No, Bill_Date, PatientName, Gender, DOB, Address, Email_Id, Mobile_No)
			VALUES (@Bill_No, @Bill_Date, @PatientName, @Gender, @DOB, @Address, @Email_Id, @Mobile_No);
		end
		else
		begin
			update Hospital_Bill set Bill_Date = @Bill_Date, PatientName = @PatientName, Gender = @Gender,
			DOB = @DOB, Address = @Address, Email_Id = @Email_Id, Mobile_No = @Mobile_No 
			where Bill_No = @Bill_No;
		end

        PRINT 'Bill inserted successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;


select * from Hospital_Bill


CREATE OR ALTER PROCEDURE usp_UpdateBill
(
    @Bill_No INT,
    @Bill_Date DATETIME,
    @Patient_Name NVARCHAR(150),
    @Gender VARCHAR(50),
    @DOB DATETIME,
    @Address NVARCHAR(MAX),
    @EmailId NVARCHAR(150),
    @Mobile_Number NVARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Check for NULL values and other constraints in all fields at once
        IF @Bill_No IS NULL OR @Bill_Date IS NULL OR @Patient_Name IS NULL OR 
           @Gender IS NULL OR (@Gender != 'Male' AND @Gender != 'Female') OR 
           @DOB IS NULL OR @Mobile_Number IS NULL OR 
           (@Mobile_Number NOT LIKE '[6-9]%' OR LEN(@Mobile_Number) != 10)
        BEGIN
            RAISERROR ('All required fields must be provided and constraints must be satisfied.', 16, 1);
            RETURN;
        END

        -- Update Hospital_Bill table
        UPDATE Hospital_Bill
        SET 
            Bill_Date = @Bill_Date,
            Patient_Name = @Patient_Name,
            Gender = @Gender,
            DOB = @DOB,
            Address = @Address,
            EmailId = @EmailId,
            Mobile_Number = @Mobile_Number
        WHERE Bill_No = @Bill_No;

        -- Check if the update was successful
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('No bill found with the specified Bill_No.', 16, 1);
            RETURN;
        END

        PRINT 'Bill updated successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO


create table Grid_Table
(
Id int primary key identity(1,1),
Bill_No int foreign key references Hospital_Bill(Bill_No),
Invest_Id int foreign key references Investigation(Invest_Id),
CreatedAt datetime default getdate()
)

drop table Grid_Table

create or alter proc usp_Inserting_Into_Grid
(
@Bill_No int,
@InvestId int
)
as
begin
  SET NOCOUNT ON;
    BEGIN TRY
        IF (@Bill_No IS NULL OR @InvestId is null)
        BEGIN
            RAISERROR ('All required fields must be provided', 16, 1);
            RETURN;
        END
		else IF not exists(select 1 from Hospital_Bill where Bill_No = @Bill_No)
        BEGIN
            RAISERROR ('HospitalId not exists', 16, 1);
            RETURN;
        END
		else
		begin

			insert into Grid_Table (Bill_No, Invest_Id) values(@Bill_No,@InvestId);
		end

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

select * from Grid_Table


create or alter proc usp_ShowGrid
(
@Bill_No int
)
as
begin
  SET NOCOUNT ON;
    BEGIN TRY
	
        IF (@Bill_No IS NULL)
        BEGIN
            RAISERROR ('Bill No& Investigation_Name field must be provided', 16, 1);
            RETURN;
        END
		else
		begin
			select inv.Investigation_Name, inv.Fees
			from Investigation inv 
			join Grid_Table gt on inv.Invest_Id=gt.Invest_Id
			where gt.Bill_No=@Bill_No;
		end

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

exec usp_ShowGrid 2

select * from Investigation
select * from Grid_Table

drop table tableGrid_Table


