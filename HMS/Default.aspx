<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HMS._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>

        <h1>Hospital Bill</h1>
    <p>
        <asp:Label ID="Label1" runat="server" Text="Bill Number"></asp:Label>
        <asp:TextBox ID="TextBox1" Visible="true" runat="server" readonly="true"></asp:TextBox>
        <asp:DropDownList ID="DropDownList3" runat="server" Visible="false" 
            AutoPostBack="True" OnSelectedIndexChanged="ddlBillIDs_SelectedIndexChanged"
            Width="200px">
        </asp:DropDownList>
        <asp:Label ID="Label2" runat="server" Text="Bill Date"></asp:Label>
        <asp:TextBox ID="TextBox2" type="date" runat="server" readonly="true"></asp:TextBox>
    </p>
    <p>
        <asp:Label ID="Label3" runat="server" Text="Patient Name"></asp:Label>
        <asp:TextBox ID="TextBox3" runat="server" ReadOnly="true"></asp:TextBox>
        <asp:Label ID="Label4" runat="server" Text="Gender"></asp:Label>
        <asp:DropDownList ID="DropDownList1" runat="server" Enabled="false">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Male</asp:ListItem>
            <asp:ListItem>Female</asp:ListItem>
        </asp:DropDownList>
        <asp:Label ID="Label5" runat="server" Text="Date of Birth"></asp:Label>
        <asp:TextBox ID="TextBox4" type="date" runat="server" ReadOnly="true"></asp:TextBox>
    </p>
    <p>
        <asp:Label ID="Label6" runat="server" Text="Address"></asp:Label>
        <asp:TextBox ID="TextBox5" runat="server" readonly="true"></asp:TextBox>
        <asp:Label ID="Label7" runat="server" Text="Email Id"></asp:Label>
        <asp:TextBox ID="TextBox7" runat="server" readonly="true"></asp:TextBox>
        <asp:Label ID="Label8" runat="server" Text="Mobile Number"></asp:Label>
        <asp:TextBox ID="TextBox6" runat="server" readonly="true"></asp:TextBox>
    </p>
    <p>
        <asp:Label ID="Label9" runat="server" Text="Investigations"></asp:Label>
        <asp:DropDownList ID="DropDownList2" runat="server" Enabled="false" Width="200px" 
          AutoPostBack="true"  OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
        </asp:DropDownList>
        <asp:Label ID="Label10" runat="server" Text="Fee"></asp:Label>
        <asp:TextBox ID="TextBox8" runat="server" readOnly="true" ></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="Add To Grid" Enabled="false" OnClick="AddToGrid" />
    </p>
    <p>
        <%--OnSelectedIndexChanged="GridView1_SelectedIndexChanged"--%>
        <asp:GridView style="border:solid 5px red; " ID="GridView1" runat="server" ShowHeaderWhenEmpty="true"
            OnRowDataBound="GridView1_RowDataBound" CellPadding="4" ForeColor="#333333" GridLines="None">

            <AlternatingRowStyle BackColor="White" />

            <Columns>
                    <asp:TemplateField HeaderText="SNo">
                        <ItemTemplate>
                            <asp:Label ID="lblSerialNumber" runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
            </Columns>

            <EditRowStyle BackColor="#2461BF" />
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F5F7FB" />
            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
            <SortedDescendingCellStyle BackColor="#E9EBEF" />
            <SortedDescendingHeaderStyle BackColor="#4870BE" />

        </asp:GridView>

<%--        <asp:GridView ID="GridView1" runat="server"
    AutoGenerateColumns="False"
    OnRowDataBound="GridView1_RowDataBound"
    BorderColor="Black"
    BorderStyle="Solid"
    BorderWidth="2px"
    CellPadding="4"
    CellSpacing="1"
    GridLines="Both"
    style="border:solid 5px red;">
    <HeaderStyle BackColor="#0033CC" ForeColor="White" Font-Bold="True" />
    <RowStyle BackColor="White" ForeColor="Black" />
    <AlternatingRowStyle BackColor="#f2f2f2" ForeColor="Black" />
    <SelectedRowStyle BackColor="#FFCC66" ForeColor="Black" Font-Bold="True" />
    <PagerStyle BackColor="#0066CC" ForeColor="White" HorizontalAlign="Center" />
    <EditRowStyle BackColor="#FFFFCC" ForeColor="Black" />
    <FooterStyle BackColor="#0033CC" ForeColor="White" Font-Bold="True" />
    <EmptyDataTemplate>
        <div style="text-align:center; color:red; font-weight:bold;">No records found.</div>
    </EmptyDataTemplate>
    <Columns>
        <asp:BoundField DataField="Investigation_Name" HeaderText="Investigation_Name" SortExpression="Investigation_Name" />
        <asp:BoundField DataField="Fees" HeaderText="Fees" SortExpression="Fees" />
        
    </Columns>
</asp:GridView>--%>


    </p>
    <p>
        <asp:Button ID="Button2" runat="server" Enabled = "true" Text="Add" OnClick="Add" />
        <asp:Button ID="Button3" runat="server" Text="Edit" OnClick="Edit" />
        <asp:Button ID="Button4" runat="server" Enabled = "false" Text="Save" OnClick="Save" />
        <asp:Button ID="Button5" runat="server" Text="Clear" OnClick="Clear" />
    </p>
    <p>&nbsp;</p>
       
    </main>

</asp:Content>
