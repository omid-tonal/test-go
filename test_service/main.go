package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", TestServer)
	http.ListenAndServe(":8080", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Test Tonal v1.0.0 %s!", r.URL.Path[1:])
}
