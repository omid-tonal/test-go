package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", TestServer)
	http.ListenAndServe(":8080", nil)
}

func TestServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Test Tonal v1.0.12 %s!", r.URL.Path[1:])
}
