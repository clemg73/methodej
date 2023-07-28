using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace methodej.Migrations
{
    /// <inheritdoc />
    public partial class removeMatterObj : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_t_e_lesson_lsn_t_e_matter_mtr_MatterId",
                table: "t_e_lesson_lsn");

            migrationBuilder.DropTable(
                name: "t_e_matter_mtr");

            migrationBuilder.DropIndex(
                name: "IX_t_e_lesson_lsn_MatterId",
                table: "t_e_lesson_lsn");

            migrationBuilder.DropColumn(
                name: "MatterId",
                table: "t_e_lesson_lsn");

            migrationBuilder.AlterColumn<string>(
                name: "usr_email",
                table: "t_e_user_usr",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(30)",
                oldMaxLength: 30);

            migrationBuilder.AlterColumn<DateTime>(
                name: "lsn_realized_date",
                table: "t_e_revision_rvs",
                type: "date",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "date");

            migrationBuilder.AddColumn<string>(
                name: "lsn_matter",
                table: "t_e_lesson_lsn",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "lsn_matter",
                table: "t_e_lesson_lsn");

            migrationBuilder.AlterColumn<string>(
                name: "usr_email",
                table: "t_e_user_usr",
                type: "nvarchar(30)",
                maxLength: 30,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<DateTime>(
                name: "lsn_realized_date",
                table: "t_e_revision_rvs",
                type: "date",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "date",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MatterId",
                table: "t_e_lesson_lsn",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "t_e_matter_mtr",
                columns: table => new
                {
                    mtr_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    mtr_name = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_t_e_matter_mtr", x => x.mtr_id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_t_e_lesson_lsn_MatterId",
                table: "t_e_lesson_lsn",
                column: "MatterId");

            migrationBuilder.AddForeignKey(
                name: "FK_t_e_lesson_lsn_t_e_matter_mtr_MatterId",
                table: "t_e_lesson_lsn",
                column: "MatterId",
                principalTable: "t_e_matter_mtr",
                principalColumn: "mtr_id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
