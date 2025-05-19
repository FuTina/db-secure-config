package main

import (
	"context"
	"fmt"

	"github.com/weaviate/weaviate-go-client/v4/weaviate"
	"github.com/weaviate/weaviate-go-client/v4/weaviate/graphql"
)

// example from https://weaviate.io/developers/weaviate/quickstart/local - import data
// and run the example
// This example demonstrates how to use the Weaviate Go client to perform a GraphQL query
// with generative search capabilities. It retrieves data from a Weaviate instance
// based on a given prompt and applies generative search to the results.

func main() {
	cfg := weaviate.Config{
		Host:   "localhost:8080",
		Scheme: "http",
	}

	client, err := weaviate.NewClient(cfg)
	if err != nil {
		fmt.Println(err)
	}

	ctx := context.Background()

	generatePrompt := "Write a tweet with emojis about these facts."

	gs := graphql.NewGenerativeSearch().GroupedResult(generatePrompt)

	response, err := client.GraphQL().Get().
		WithClassName("Question").
		WithFields(
			graphql.Field{Name: "question"},
			graphql.Field{Name: "answer"},
			graphql.Field{Name: "category"},
		).
		WithGenerativeSearch(gs).
		WithNearText(client.GraphQL().NearTextArgBuilder().
			WithConcepts([]string{"biology"})).
		WithLimit(2).
		Do(ctx)

	if err != nil {
		panic(err)
	}
	fmt.Printf("%v", response)
}
