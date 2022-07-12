global using ElectronNET.API;
global using ElectronNET.API.Entities;
global using Google.Cloud.Firestore;
global using Microsoft.AspNetCore.Mvc;
global using Qemma.APP.Attributes;
global using Qemma.APP.Database.Firebase;
global using Qemma.APP.Database.Models;
global using Qemma.APP.Enums;
global using Qemma.APP.Extensions;
global using Qemma.APP.Helper;
global using System.ComponentModel;
global using System.Linq.Expressions;
global using System.Reflection;
global using System.Text.Json;
global using System.Text.Json.Serialization;


namespace Qemma.APP
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers().AddJsonOptions(config =>
            {
                config.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
            });

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen(options =>
            {
                options.CustomSchemaIds(type => type.FullName);
            });

            services.AddCors();

            /* inject firestore as singleton */
            var settings = Configuration.GetRequiredSection("Firebase")
                .Get<Dictionary<string, object>>();
            string jsonString = JsonSerializer.Serialize(settings);
            var firestoreDb = new FirestoreDbBuilder
            {
                ProjectId = settings["project_id"].ToString(),
                JsonCredentials = jsonString
            }.Build();
            services.AddSingleton(firestoreDb);
            InitFirestoreGroups(firestoreDb);
            AddFirestoreListeners(firestoreDb);

            services.AddScoped(typeof(FirestoreDatabase<>));

            // In production, the VUE files will be served from this directory
            services.AddSpaStaticFiles(configuration =>
            {
                configuration.RootPath = "wwwroot";
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseCors(options => options
                .SetIsOriginAllowed(x => _ = true)
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials()
            );
            app.UseHttpsRedirection();
            app.UseDefaultFiles();
            app.UseStaticFiles();

            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            if (HybridSupport.IsElectronActive)
            {
                ElectronBootstrap();
            }
        }

        public async void ElectronBootstrap()
        {
            var browserWindow = await Electron.WindowManager.CreateWindowAsync(new BrowserWindowOptions
            {
                Show = false,
                Frame = false,
            });
            browserWindow.LoadURL("/");
            browserWindow.SetMenuBarVisibility(false);
            browserWindow.Maximize();

            await browserWindow.WebContents.Session.ClearCacheAsync();

            browserWindow.OnReadyToShow += () => browserWindow.Show();
            browserWindow.SetTitle("Al-Qemma");
            Electron.IpcMain.On("close", (args) =>
            {
                browserWindow.Close();
            });
            Electron.IpcMain.On("minimize", (args) =>
            {
                browserWindow.Minimize();
            });
            Electron.IpcMain.On("maximize", (args) =>
            {
                browserWindow.Maximize();
            });
        }

        private static void InitFirestoreGroups(FirestoreDb db)
        {
            var stateTask = db.Collection("state").GetSnapshotAsync();
            stateTask.Wait();
            var state = stateTask.Result;
            if (!state.Any())
            {
                var groupCollectionName = typeof(Group).GetCollectionName();
                for (int i = 1; i <= 12; i++)
                {
                    var groupAddTask = db.Collection(groupCollectionName).AddAsync(new Group
                    {
                        Name = $"lookups.year.{i}",
                        Price = 0,
                        Subject = $"lookups.subject.english",
                        Year = (Year)Enum.Parse(typeof(Year), $"{i}")
                    });
                    groupAddTask.Wait();
                }
                var addTask = db.Collection("state").AddAsync(new { state = "done" });
                addTask.Wait();
            }
        }

        private static void AddFirestoreListeners(FirestoreDb db)
        {
            db.Collection(typeof(Student).GetCollectionName()).WhereGreaterThanOrEqualTo("regisrationDate", Timestamp.FromDateTime(DateTime.UtcNow)).Listen(snapshot =>
            {
                var mainWindow = Electron.WindowManager.BrowserWindows.FirstOrDefault();
                if (mainWindow is null) return;
                foreach (var change in snapshot.Changes)
                {
                    var student = change.Document.ConvertTo<Student>();
                    if (change.ChangeType == DocumentChange.Type.Added)
                    {
                        Electron.IpcMain.Send(mainWindow, "student_added", student);
                    }
                    else if (change.ChangeType == DocumentChange.Type.Modified)
                    {
                        Electron.IpcMain.Send(mainWindow, "student_modified", student);
                    }
                }
            });
        }
    }
}
