using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace HMS
{
    public partial class _Default : Page
    {
        SqlConnection sqlConnection = new SqlConnection(@"Data Source=DELL\SQLEXPRESS;Initial Catalog=HospitalManagementSystemDb;Integrated Security=True;");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillDrop();
            }
        }

        private void FillDrop()
        {
            sqlConnection.Open();
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter("select * from Investigation", sqlConnection);
            DataTable dt = new DataTable();
            sqlDataAdapter.Fill(dt);
            DropDownList2.DataSource = dt;
            DropDownList2.DataTextField = "Investigation_Name";
            DropDownList2.DataValueField = "Invest_Id";
            DropDownList2.DataBind();
            sqlConnection.Close();
        }

        void EnableTags()
        {
            TextBox2.ReadOnly = TextBox3.ReadOnly = 
                TextBox4.ReadOnly= TextBox5.ReadOnly = TextBox7.ReadOnly = TextBox6.ReadOnly = false;
            DropDownList1.Enabled = DropDownList2.Enabled = Button1.Enabled = true;
        }

        void DisableTags()
        {
            TextBox2.ReadOnly = TextBox3.ReadOnly = TextBox4.ReadOnly = 
                TextBox5.ReadOnly = TextBox7.ReadOnly = TextBox6.ReadOnly = true;
            DropDownList1.Enabled = DropDownList2.Enabled = Button1.Enabled = false;
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void AddToGrid(object sender, EventArgs e)
        {
            if (DropDownList2.SelectedValue == "")
            {
                return;
            }
            SqlCommand cmd = new SqlCommand("usp_Inserting_Into_Grid", sqlConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            if (TextBox1.Visible)
                cmd.Parameters.AddWithValue("@Bill_No", TextBox1.Text);
            else
                cmd.Parameters.AddWithValue("@Bill_No", DropDownList3.SelectedValue);

            cmd.Parameters.AddWithValue("@InvestId", DropDownList2.SelectedValue);

            sqlConnection.Open();
            cmd.ExecuteNonQuery();
            sqlConnection.Close();
            ShowGrid();
        }

        void ShowGrid()
        {
            if (DropDownList3.SelectedValue != "")
            {
                GridView1.Visible = true;
                SqlDataAdapter adp = null;
                if (TextBox1.Visible)
                    adp = new SqlDataAdapter("exec usp_ShowGrid " + TextBox1.Text, sqlConnection);
                else
                    adp = new SqlDataAdapter("exec usp_ShowGrid " + DropDownList3.SelectedValue, sqlConnection);
                sqlConnection.Open();
                DataTable dt = new DataTable();
                adp.Fill(dt);
                sqlConnection.Close();
                //if (dt.Rows.Count == 0)  
                //{
                //    dt.Rows.Add(dt.NewRow()); // Add a dummy row
                //}
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    // Check if this is the dummy row
            //    if (e.Row.Cells[0].Text == "&nbsp;")
            //    {
            //        e.Row.Visible = false;
            //    }
            //}

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblSerialNumber = (Label)e.Row.FindControl("lblSerialNumber");
                lblSerialNumber.Text = (e.Row.RowIndex + 1).ToString();
            }


        }

        protected void Add(object sender, EventArgs e)
        {

            EnableTags();
            Button2.Enabled = false;
            Button4.Enabled = true;
            int lastRecordBillId = GetLastBillId();
            TextBox1.Text = (lastRecordBillId + 1).ToString();

        }
        private int GetLastBillId()
        {
            int lastBillId = 0;
            
            string query = "SELECT ISNULL(MAX(Bill_No), 0) FROM Hospital_Bill";
            using (SqlCommand cmd = new SqlCommand(query, sqlConnection))
            {
                sqlConnection.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    lastBillId = Convert.ToInt32(result);
                }
                sqlConnection.Close();
            }
            return lastBillId;
        }

        protected void Edit(object sender, EventArgs e)
        {
            Button2.Enabled = false;
            Button4.Enabled = true;
            TextBox1.Visible = false;
            DropDownList3.Visible = true;
            
            sqlConnection.Open();
            SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from Hospital_Bill", sqlConnection);
            DataTable dataTable = new DataTable();
            dataAdapter.Fill(dataTable);
            DropDownList3.DataSource = dataTable;
            DropDownList3.DataTextField = "Bill_No";
            DropDownList3.DataBind();
            sqlConnection.Close();

            if (DropDownList3.SelectedValue != "0")
            {
                EnableTags();
                int billId = int.Parse(DropDownList3.SelectedValue);
                DisplayBillDetails(billId);
                ShowGrid();
            }
        }


        protected void ddlBillIDs_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropDownList3.SelectedValue != "0")
            {
                EnableTags();
                int billId = int.Parse(DropDownList3.SelectedValue);
                DisplayBillDetails(billId);
                ShowGrid();
            }
        }
        void DisplayBillDetails(int billId)
        {
            string fetchQuery = "select * from Hospital_Bill where Bill_No =" + billId;
            sqlConnection.Open();
            SqlCommand cmd = new SqlCommand(fetchQuery, sqlConnection);
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                TextBox2.Text = Convert.ToDateTime(reader["Bill_Date"]).ToString("yyyy-MM-dd");
                TextBox3.Text = reader["PatientName"].ToString();
                DropDownList1.SelectedValue = reader["Gender"].ToString();
                TextBox4.Text = Convert.ToDateTime(reader["DOB"]).ToString("yyyy-MM-dd");
                TextBox5.Text = reader["Address"].ToString();
                TextBox7.Text = reader["Email_Id"].ToString();
                TextBox6.Text = reader["Mobile_No"].ToString();
            }
            sqlConnection.Close();
        }

        protected void Save(object sender, EventArgs e)
        {
            Console.WriteLine("hvbzkcnbdvS");
            using (SqlCommand cmd = new SqlCommand("usp_InsertBill", sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (TextBox1.Visible) {
                    Console.WriteLine(TextBox1.Text);
                    cmd.Parameters.AddWithValue("@Bill_No", TextBox1.Text);
                }
                else
                {
                    Console.WriteLine(DropDownList3.SelectedValue);
                    cmd.Parameters.AddWithValue("@Bill_No", DropDownList3.SelectedValue);
                }

                cmd.Parameters.AddWithValue("@Bill_Date", TextBox2.Text);
                cmd.Parameters.AddWithValue("@PatientName", TextBox3.Text);
                cmd.Parameters.AddWithValue("@Gender", DropDownList1.Text);
                cmd.Parameters.AddWithValue("@DOB", TextBox4.Text);
                cmd.Parameters.AddWithValue("@Address", TextBox5.Text);
                cmd.Parameters.AddWithValue("@Email_Id", TextBox7.Text);
                cmd.Parameters.AddWithValue("@Mobile_No", TextBox6.Text);
                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                sqlConnection.Close();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "alert ('Insertion data is succuss');", true);
                ClearFields();
                Button4.Enabled = false;
                Button2.Enabled = true;
                TextBox1.Visible = true;
                DropDownList3.Visible = false;
                DisableTags();
            }
        }
        void ClearFields()
        {
            TextBox1.Text = TextBox2.Text = TextBox3.Text = TextBox4.Text =
                TextBox5.Text = TextBox7.Text = TextBox6.Text = TextBox8.Text = "";
            DropDownList1.SelectedValue = "";
            //DropDownList2.SelectedValue = "";
            GridView1.Visible=false;
            FillDrop();
        }
        protected void Clear(object sender, EventArgs e)
        {
            TextBox1.Visible = true;
            DropDownList3.Visible = false;
            Button2.Enabled = true;
            Button4.Enabled = false;
            ClearFields();
        }

        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlConnection.Open();
            SqlCommand cmd = new SqlCommand("select Fees from Investigation where Invest_Id =" + DropDownList2.SelectedValue, sqlConnection);
            SqlDataReader sqlData = cmd.ExecuteReader();
            if (sqlData.Read())
            {
                TextBox8.Text = sqlData.GetDecimal(0).ToString();
            }
            else
            {
                TextBox8.Text = "";
            }
            sqlConnection.Close();
        }
    }
}