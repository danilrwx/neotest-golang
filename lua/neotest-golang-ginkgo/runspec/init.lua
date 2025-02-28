--- Build the neotest.Runspec specification for a test execution.

local M = {}

M.dir = require("neotest-golang-ginkgo.runspec.dir")
M.file = require("neotest-golang-ginkgo.runspec.file")
M.namespace = require("neotest-golang-ginkgo.runspec.namespace")
M.test = require("neotest-golang-ginkgo.runspec.test")

return M
