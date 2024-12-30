package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestFrontMatter(t *testing.T) {
	tests := []struct {
		name     string
		src      []byte
		expected map[string]any
	}{
		{
			name: "yaml",
			src:  []byte("---\ntitle: hoge\ntopics: [hoge, piyo]\n---\n\nbody"),
			expected: map[string]any{
				"title":  "hoge",
				"topics": []any{"hoge", "piyo"},
			},
		},
		{
			name: "toml",
			src:  []byte("+++\ntitle = 'hoge'\ntopics = ['hoge', 'piyo']\n+++\n\nbody2"),
			expected: map[string]any{
				"title":  "hoge",
				"topics": []any{"hoge", "piyo"},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := FrontMatter(tt.src)
			require.NoError(t, err)
			assert.Equal(t, tt.expected, got)
		})
	}
}
