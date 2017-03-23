#
# Cookbook Name:: beachhead-cookbook
# Recipe:: local_repo
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe "beachhead::http_server"
include_recipe "beachhead::create_rpm_artifacts"
