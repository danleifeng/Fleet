# Copyright (c) 2020 PaddlePaddle Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
import grpc

from . import barrier_server_pb2 as barrier__server__pb2


class BarrierServerStub(object):
    """Missing associated documentation comment in .proto file"""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.ReadyToPass = channel.unary_unary(
            '/barrier.BarrierServer/ReadyToPass',
            request_serializer=barrier__server__pb2.Request.SerializeToString,
            response_deserializer=barrier__server__pb2.Res.FromString, )
        self.Exit = channel.unary_unary(
            '/barrier.BarrierServer/Exit',
            request_serializer=barrier__server__pb2.Request.SerializeToString,
            response_deserializer=barrier__server__pb2.Res.FromString, )
        self.SayHello = channel.unary_unary(
            '/barrier.BarrierServer/SayHello',
            request_serializer=barrier__server__pb2.Request.SerializeToString,
            response_deserializer=barrier__server__pb2.Res.FromString, )


class BarrierServerServicer(object):
    """Missing associated documentation comment in .proto file"""

    def ReadyToPass(self, request, context):
        """Missing associated documentation comment in .proto file"""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def Exit(self, request, context):
        """Missing associated documentation comment in .proto file"""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def SayHello(self, request, context):
        """Missing associated documentation comment in .proto file"""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_BarrierServerServicer_to_server(servicer, server):
    rpc_method_handlers = {
        'ReadyToPass': grpc.unary_unary_rpc_method_handler(
            servicer.ReadyToPass,
            request_deserializer=barrier__server__pb2.Request.FromString,
            response_serializer=barrier__server__pb2.Res.SerializeToString, ),
        'Exit': grpc.unary_unary_rpc_method_handler(
            servicer.Exit,
            request_deserializer=barrier__server__pb2.Request.FromString,
            response_serializer=barrier__server__pb2.Res.SerializeToString, ),
        'SayHello': grpc.unary_unary_rpc_method_handler(
            servicer.SayHello,
            request_deserializer=barrier__server__pb2.Request.FromString,
            response_serializer=barrier__server__pb2.Res.SerializeToString, ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
        'barrier.BarrierServer', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler, ))


# This class is part of an EXPERIMENTAL API.
class BarrierServer(object):
    """Missing associated documentation comment in .proto file"""

    @staticmethod
    def ReadyToPass(request,
                    target,
                    options=(),
                    channel_credentials=None,
                    call_credentials=None,
                    compression=None,
                    wait_for_ready=None,
                    timeout=None,
                    metadata=None):
        return grpc.experimental.unary_unary(
            request, target, '/barrier.BarrierServer/ReadyToPass',
            barrier__server__pb2.Request.SerializeToString,
            barrier__server__pb2.Res.FromString, options, channel_credentials,
            call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def Exit(request,
             target,
             options=(),
             channel_credentials=None,
             call_credentials=None,
             compression=None,
             wait_for_ready=None,
             timeout=None,
             metadata=None):
        return grpc.experimental.unary_unary(
            request, target, '/barrier.BarrierServer/Exit',
            barrier__server__pb2.Request.SerializeToString,
            barrier__server__pb2.Res.FromString, options, channel_credentials,
            call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def SayHello(request,
                 target,
                 options=(),
                 channel_credentials=None,
                 call_credentials=None,
                 compression=None,
                 wait_for_ready=None,
                 timeout=None,
                 metadata=None):
        return grpc.experimental.unary_unary(
            request, target, '/barrier.BarrierServer/SayHello',
            barrier__server__pb2.Request.SerializeToString,
            barrier__server__pb2.Res.FromString, options, channel_credentials,
            call_credentials, compression, wait_for_ready, timeout, metadata)
