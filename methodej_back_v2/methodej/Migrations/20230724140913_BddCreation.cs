using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace methodej.Migrations
{
    /// <inheritdoc />
    public partial class BddCreation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.CreateTable(
                name: "t_e_user_usr",
                columns: table => new
                {
                    usr_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    usr_email = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    usr_password = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    usr_premium = table.Column<bool>(type: "bit", nullable: false),
                    usr_creation_date = table.Column<DateTime>(type: "date", nullable: false),
                    usr_study_program = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_t_e_user_usr", x => x.usr_id);
                });

            migrationBuilder.CreateTable(
                name: "t_e_lesson_lsn",
                columns: table => new
                {
                    lsn_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    lsn_name = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    MatterId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    lsn_creation_date = table.Column<DateTime>(type: "date", nullable: false),
                    lsn_logo_name = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_t_e_lesson_lsn", x => x.lsn_id);
                    table.ForeignKey(
                        name: "FK_t_e_lesson_lsn_t_e_matter_mtr_MatterId",
                        column: x => x.MatterId,
                        principalTable: "t_e_matter_mtr",
                        principalColumn: "mtr_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_t_e_lesson_lsn_t_e_user_usr_UserId",
                        column: x => x.UserId,
                        principalTable: "t_e_user_usr",
                        principalColumn: "usr_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_revision_rvs",
                columns: table => new
                {
                    rvs_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    lsn_planned_date = table.Column<DateTime>(type: "date", nullable: false),
                    lsn_realized_date = table.Column<DateTime>(type: "date", nullable: false),
                    LessonId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_t_e_revision_rvs", x => x.rvs_id);
                    table.ForeignKey(
                        name: "FK_t_e_revision_rvs_t_e_lesson_lsn_LessonId",
                        column: x => x.LessonId,
                        principalTable: "t_e_lesson_lsn",
                        principalColumn: "lsn_id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_t_e_lesson_lsn_MatterId",
                table: "t_e_lesson_lsn",
                column: "MatterId");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_lesson_lsn_UserId",
                table: "t_e_lesson_lsn",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_revision_rvs_LessonId",
                table: "t_e_revision_rvs",
                column: "LessonId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "t_e_revision_rvs");

            migrationBuilder.DropTable(
                name: "t_e_lesson_lsn");

            migrationBuilder.DropTable(
                name: "t_e_matter_mtr");

            migrationBuilder.DropTable(
                name: "t_e_user_usr");
        }
    }
}
