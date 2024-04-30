package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func GetDefault(c echo.Context) error {
	return c.String(http.StatusOK, "Hello world !")
}
