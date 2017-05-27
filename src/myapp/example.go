package main

import (
	"config"
	"flag"
	"fmt"
	"info"
	"log"
	"os"
	"path/filepath"

	"github.com/fatih/color"
)

func init() {
	flag.StringVar(&config.ConfigString, "-string", "default string", "String argument")
	flag.IntVar(&config.ConfigInt, "-int", 123, "IntegerArgument")
	flag.Usage = func() {
		yellow := color.New(color.FgYellow).SprintFunc()
		fmt.Fprintf(os.Stderr, "Usage of %s:\n", yellow(filepath.Base(os.Args[0])))
		flag.PrintDefaults()
	}
}

func main() {
	log.Println("*> Build date    :", info.BuildTime)
	log.Println("*> Commit        :", info.CommitHash)
	log.Println("*> Branch        :", info.BranchName)
	log.Println("*> Golang Version:", info.GolangVersion)

	// parse the command line flags
	flag.Parse()
}
