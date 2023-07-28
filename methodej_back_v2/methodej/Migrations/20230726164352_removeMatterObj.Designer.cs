﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using methodej.Data;

#nullable disable

namespace methodej.Migrations
{
    [DbContext(typeof(MethodejDBContext))]
    [Migration("20230726164352_removeMatterObj")]
    partial class removeMatterObj
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.9")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("methodej.Models.Lesson", b =>
                {
                    b.Property<int>("LessonId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("lsn_id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("LessonId"));

                    b.Property<DateTime>("CreationDate")
                        .HasColumnType("date")
                        .HasColumnName("lsn_creation_date");

                    b.Property<string>("LogoName")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("nvarchar(30)")
                        .HasColumnName("lsn_logo_name");

                    b.Property<string>("Matter")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)")
                        .HasColumnName("lsn_matter");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("nvarchar(30)")
                        .HasColumnName("lsn_name");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("LessonId");

                    b.HasIndex("UserId");

                    b.ToTable("t_e_lesson_lsn");
                });

            modelBuilder.Entity("methodej.Models.Revision", b =>
                {
                    b.Property<int>("RevisionId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("rvs_id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RevisionId"));

                    b.Property<int?>("LessonId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("PlannedDate")
                        .IsRequired()
                        .HasColumnType("date")
                        .HasColumnName("lsn_planned_date");

                    b.Property<DateTime?>("RealizedDate")
                        .HasColumnType("date")
                        .HasColumnName("lsn_realized_date");

                    b.HasKey("RevisionId");

                    b.HasIndex("LessonId");

                    b.ToTable("t_e_revision_rvs");
                });

            modelBuilder.Entity("methodej.Models.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("usr_id");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserId"));

                    b.Property<DateTime>("CreationDate")
                        .HasColumnType("date")
                        .HasColumnName("usr_creation_date");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)")
                        .HasColumnName("usr_email");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)")
                        .HasColumnName("usr_password");

                    b.Property<bool>("Premium")
                        .HasColumnType("bit")
                        .HasColumnName("usr_premium");

                    b.Property<string>("StudyProgram")
                        .HasMaxLength(50)
                        .HasColumnType("nvarchar(50)")
                        .HasColumnName("usr_study_program");

                    b.HasKey("UserId");

                    b.ToTable("t_e_user_usr");
                });

            modelBuilder.Entity("methodej.Models.Lesson", b =>
                {
                    b.HasOne("methodej.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("methodej.Models.Revision", b =>
                {
                    b.HasOne("methodej.Models.Lesson", null)
                        .WithMany("Revisions")
                        .HasForeignKey("LessonId");
                });

            modelBuilder.Entity("methodej.Models.Lesson", b =>
                {
                    b.Navigation("Revisions");
                });
#pragma warning restore 612, 618
        }
    }
}
