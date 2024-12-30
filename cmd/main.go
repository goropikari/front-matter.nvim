package main

import (
	"log"
	"os"

	"github.com/neovim/go-client/nvim"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/text"

	"go.abhg.dev/goldmark/frontmatter"
)

func FrontMatters(v *nvim.Nvim, paths []string) ([]map[string]any, error) {
	data := make([][]byte, len(paths))
	for i, path := range paths {
		datum, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		data[i] = datum
	}

	metadatas := make([]map[string]any, len(paths))
	for i, datum := range data {
		md, err := FrontMatter(datum)
		if err != nil {
			return nil, err
		}
		metadatas[i] = md
	}

	return metadatas, nil
}

func FrontMatter(data []byte) (map[string]any, error) {
	markdown := goldmark.New(
		goldmark.WithExtensions(
			&frontmatter.Extender{
				Mode: frontmatter.SetMetadata,
			},
		),
	)

	doc := markdown.Parser().Parse(text.NewReader(data))
	metadata := doc.OwnerDocument().Meta()

	return metadata, nil
}

func main() {
	// Turn off timestamps in output.
	log.SetFlags(0)

	// Direct writes by the application to stdout garble the RPC stream.
	// Redirect the application's direct use of stdout to stderr.
	stdout := os.Stdout
	os.Stdout = os.Stderr

	// Create a client connected to stdio. Configure the client to use the
	// standard log package for logging.
	v, err := nvim.New(os.Stdin, stdout, stdout, log.Printf)
	if err != nil {
		log.Fatal(err)
	}

	// Register function with the client.
	v.RegisterHandler("front_matter", FrontMatters)

	// Run the RPC message loop. The Serve function returns when
	// nvim closes.
	if err := v.Serve(); err != nil {
		log.Fatal(err)
	}
}
