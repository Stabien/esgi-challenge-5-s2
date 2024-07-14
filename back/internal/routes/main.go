package routes

import (
	"easynight/internal/controllers"
	"easynight/internal/middlewares"
	"easynight/internal/ws"

	"github.com/labstack/echo/v4"
	echoSwagger "github.com/swaggo/echo-swagger"
)

func InitRouter(e *echo.Echo) {
	e.GET("/swagger/*", echoSwagger.WrapHandler)

	// e.GET("/ws", ws.HandleWebSocket)
	e.GET("/ws/room", ws.HandleRoomWebSocket)

	e.POST("/event", middlewares.CheckUserRole(controllers.CreateEvent, "organizer"))
	e.DELETE("/event/:id", middlewares.CheckEventBelongsToOrganizer(controllers.DeleteEvent))
	e.PATCH("/event/:id", middlewares.CheckEventBelongsToOrganizer(controllers.UpdateEvent))
	e.GET("/event/:id", controllers.GetEvent)
	e.GET("/events", controllers.GetAllEvents)
	e.GET("/events/pending", controllers.GetAllPendingEvents)
	e.PATCH("/events/:id/validate", controllers.ValidateEvent)
	e.GET("/events/today", controllers.GetAllEventsToday)
	// e.POST("/event/:id/code", controllers.CreateCode)
	e.POST("/event/join/:code", controllers.JoinEvent)
	e.GET("/events/organizer", controllers.GetEventsByOrganizer)

	e.GET("/reservations/isreserv/:customerId/:eventId", controllers.IsReserv)
	e.GET("/reservations/isValid/:reservationId", controllers.IsValid)

	e.POST("/reservations", middlewares.CheckUserRole(controllers.PostReservation, "customer"))
	e.DELETE("/reservations", controllers.DeleteReservation) // TODO: pass customer with params instead of body
	e.GET("/reservations/:customerId", middlewares.CheckCustomerIdParam(controllers.GetReservationsbyUser))

	e.POST("/auth", controllers.Authentication)
	e.POST("/customers", controllers.CustomerRegistration)
	e.POST("/organizers", controllers.OrganizerRegistration)
	// e.GET("/role", controllers.GetRole)
	e.GET("/users/custom/:id", controllers.GetUserByIdCustomer)
	e.GET("/users/orga/:id", controllers.GetUserByIdOrga)
	e.PATCH("/users/orga/:id", middlewares.CheckUserId(controllers.UpdateUserByIdOrga))
	e.PATCH("/users/custom/:id", middlewares.CheckUserId(controllers.UpdateUserByIdCustomer))

	e.POST("/send-notification", controllers.SendNotification)
	e.GET("/logs", middlewares.CheckUserRole(controllers.GetAllLogs, "admin")) // TODO: add middleware to check if user is admin

	// Admin
	// Groupes de routes protégées par le middleware CheckAdminMiddleware
	// adminRoutes := authRoutes.Group("/admin")
	// adminRoutes.Use(middlewares.CheckAdminMiddleware)

	// User routes
	e.POST("/users", controllers.CreateUser)
	e.GET("/users", controllers.GetAllUsers)
	e.GET("/users/:id", controllers.GetUser)
	e.PATCH("/users/:id", middlewares.CheckUserId(controllers.UpdateUser))
	e.DELETE("/users/:id", middlewares.CheckUserRole(controllers.DeleteUser, "admin"))
	// Forgot password
	e.POST("/send-mail-forgot-password", controllers.SendMailForgotPassword)
	e.POST("/forgot-password", controllers.ForgotPassword)

	// Reservation routes
	e.POST("/reservations", middlewares.CheckUserRole(controllers.PostReservation, "customer"))
	// e.GET("/reservations/:id", controllers.GetReservation)
	e.PUT("/reservations/:id", middlewares.CheckCustomerIdBody(controllers.UpdateReservation))
	e.DELETE("/reservations/:id", middlewares.CheckCustomerIdBody(controllers.DeleteReservation))

	// Chat routes
	e.POST("/chat", controllers.CreateChat)
	e.GET("/chat/:id", controllers.GetChat)
	e.PUT("/chat/:id", controllers.UpdateChat)
	e.DELETE("/chat/:id", controllers.DeleteChat)

	// Message routes
	e.POST("/messages", middlewares.CheckSenderBelongsToEvent(controllers.CreateMessage))
	e.GET("/messages/:id", middlewares.CheckMessageBelongsToOrganizer(controllers.GetMessage))
	e.PUT("/messages/:id", middlewares.CheckMessageBelongsToOrganizer(controllers.UpdateMessage))
	e.DELETE("/messages/:id", middlewares.CheckMessageBelongsToOrganizer(controllers.DeleteMessage))
	e.GET("/messages/event/:id", middlewares.CheckSenderBelongsToEvent(controllers.GetAllMessageByEvent))

	// Event routes
	e.POST("/events", controllers.CreateEvent)
	// e.GET("/events/:id", controllers.GetEvent)
	// e.PATCH("/events/:id", controllers.UpdateEvent)
	// e.DELETE("/events/:id", controllers.DeleteEvent)

	// Rate routes
	e.POST("/rates", middlewares.CheckUserRole(controllers.CreateRate, "customer"))
	e.GET("/rates/:id", controllers.GetRate)
	e.GET("/rates", controllers.GetAllRates)
	e.PUT("/rates/:id", middlewares.CheckUserId(controllers.UpdateRate))
	e.DELETE("/rates/:id", middlewares.CheckUserId(controllers.DeleteRate))

	// Organizer routes
	e.POST("/organizers", controllers.CreateOrganizer)
	e.GET("/organizers/:id", controllers.GetOrganizer)
	e.GET("/organizers", controllers.GetAllOrganizers)
	e.PUT("/organizers/:id", middlewares.CheckUserId(controllers.UpdateOrganizer))
	e.DELETE("/organizers/:id", middlewares.CheckUserRole(controllers.DeleteOrganizer, "admin"))
	e.GET("/organizers/id/:id", controllers.GetOrganizerID)

	// Notification routes
	e.POST("/notifications", controllers.CreateNotification)
	e.GET("/notifications/:id", controllers.GetNotification)
	e.GET("/notifications/:id", controllers.GetAllNotifications)
	e.PUT("/notifications/:id", controllers.UpdateNotification)
	e.DELETE("/notifications/:id", controllers.DeleteNotification)

	// Feature flipping
	e.GET("/features", middlewares.CheckUserRole(controllers.GetAllFeatures, "admin"))
	e.GET("/features/:name", middlewares.CheckUserRole(controllers.IsEnabled, "admin"))
	e.PATCH("/features", middlewares.CheckUserRole(controllers.UpdateState, "admin"))
}
