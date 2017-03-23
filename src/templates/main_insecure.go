package main

import (
  "flag"
  "net/http"
  "path"
  "strings"

  "github.com/golang/glog"
  "github.com/grpc-ecosystem/grpc-gateway/runtime"
  "golang.org/x/net/context"
  "google.golang.org/grpc"
  "pb"
)

var (
  {{#each protos}}
    {{#each serviceList}}
  {{varName name}} = flag.String("{{endpoint name}}", "{{../../grpc_host}}", "endpoint of {{name}}")
    {{/each}}
  {{/each}}
  swaggerDir = flag.String("swagger_dir", ".", "path to the directory which contains swagger definitions")
)

// newGateway returns a new gateway server which translates HTTP into gRPC.
func newGateway(ctx context.Context, opts ...runtime.ServeMuxOption) (http.Handler, error) {
  mux := runtime.NewServeMux(opts...)
  dialOpts := []grpc.DialOption{grpc.WithInsecure()}

  {{#each protos}}
    {{#each serviceList}}
      {{#if @index}}
  err = {{pbName ../pb_package}}.{{registerName name}}(ctx, mux, *{{varName name}}, dialOpts)
  if err != nil {
    return nil, err
  }
      {{else}}
  err := {{pbName ../pb_package}}.{{registerName name}}(ctx, mux, *{{varName name}}, dialOpts)
  if err != nil {
    return nil, err
  }
      {{/if}}
    {{/each}}
  {{/each}}

  return mux, nil
}

func serveSwagger(w http.ResponseWriter, r *http.Request) {
  if !strings.HasSuffix(r.URL.Path, ".swagger.json") {
    glog.Errorf("Not Found: %s", r.URL.Path)
    http.NotFound(w, r)
    return
  }

  glog.Infof("Serving %s", r.URL.Path)
  p := strings.TrimPrefix(r.URL.Path, "/swagger/")
  p = path.Join(*swaggerDir, p)
  http.ServeFile(w, r, p)
}

// allowCORS allows Cross Origin Resoruce Sharing from any origin.
// Don't do this without consideration in production systems.
func allowCORS(h http.Handler) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    if origin := r.Header.Get("Origin"); origin != "" {
      w.Header().Set("Access-Control-Allow-Origin", origin)
      if r.Method == "OPTIONS" && r.Header.Get("Access-Control-Request-Method") != "" {
        preflightHandler(w, r)
        return
      }
    }
    h.ServeHTTP(w, r)
  })
}

func preflightHandler(w http.ResponseWriter, r *http.Request) {
  headers := []string{"Content-Type", "Accept"}
  w.Header().Set("Access-Control-Allow-Headers", strings.Join(headers, ","))
  methods := []string{"GET", "HEAD", "POST", "PUT", "DELETE"}
  w.Header().Set("Access-Control-Allow-Methods", strings.Join(methods, ","))
  glog.Infof("preflight request for %s", r.URL.Path)
  return
}

// Run starts a HTTP server and blocks forever if successful.
func Run(address string, opts ...runtime.ServeMuxOption) error {
  ctx := context.Background()
  ctx, cancel := context.WithCancel(ctx)
  defer cancel()

  mux := http.NewServeMux()
  mux.HandleFunc("/swagger/", serveSwagger)

  gw, err := newGateway(ctx, opts...)
  if err != nil {
    return err
  }
  mux.Handle("/", gw)

  return http.ListenAndServe(address, allowCORS(mux))
}

func main() {
  flag.Parse()
  defer glog.Flush()

  if err := Run(":{{port}}"); err != nil {
    glog.Fatal(err)
  }
}
