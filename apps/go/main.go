package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type Request struct {
	Name string `json:"name" binding:"required,min=1,max=100" validate:"required,min=1,max=100"`
}

type Response struct {
	Data string `json:"data"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

func main() {
	router := gin.Default()

	router.POST("/", func(c *gin.Context) {
		var req Request
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid request body"})
			return
		}

		c.JSON(http.StatusOK, Response{
			Data: "Hello, \"" + req.Name + "\"!",
		})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	router.Run(":" + port)
}
