#!/bin/bash

# Hit the health check endpoint
curl http://localhost:4000/health

# Expected response: "This is the health check"

# Test the database connection
curl http://localhost:4000/transaction

# Expected response:
# {"result":[{"id":1,"amount":400,"description":"groceries"},{"id":2,"amount":100,"description":"class"},{"id":3,"amount":200,"description":"other groceries"},{"id":4,"amount":10,"description":"brownies"}]}