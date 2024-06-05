> 有关 OTLPHTTP 协议的更多细节请参考官方文档。

# 接口描述

| KEY          | VALUE                                   | REMARKS                                                                          |
|--------------|-----------------------------------------|----------------------------------------------------------------------------------|
| Protocol     | HTTP                                    |                                                                                  |
| Path         | /v1/traces                              |                                                                                  |
| Method       | POST                                    |                                                                                  |
| Content-Type | application/json application/x-protobuf | 支持两种类型的 content-type，分别时 json 和protobuf，protobuf 是 otel 的默认项。 |


# 示例
## 示例一：JSON Protobuf Encoding
使用 json 作为 http 请求的 body 来上报调用链数据。

```bash
curl -XPOST http://localhost:4318/v1/traces -H "content-type: application/json" -d @trace.json
```

`trace.json` 文件内容如下所示：

```json
{
    "resourceSpans": [
        {
            "resource": {
                "attributes": [
                    {
                        "key": "service.name",
                        "value": {
                            "stringValue": "test-service"
                        }
                    }
                ]
            },
            "scopeSpans": [
                {
                    "scope": {
                        "name": "example.com/basic"
                    },
                    "spans": [
                        {
                            "traceId": "d5c1cb5ba7804dad6e6b743287d147ef",
                            "spanId": "b437939d3d19c621",
                            "name": "main",
                            "kind": "SPAN_KIND_INTERNAL",
                            "startTimeUnixNano": "1717479559872305000",
                            "endTimeUnixNano": "1717479559872332208",
                            "attributes": [
                                {
                                    "key": "key1",
                                    "value": {
                                        "stringValue": "value1"
                                    }
                                }
                            ],
                            "status": {}
                        }
                    ]
                }
            ]
        }
    ]
}
```

## 示例二：Binary Protobuf Encoding
使用 protobuf 作为 HTTP 请求的 body 来上报调用链数据。
protobuf 生成方式：使用 buf 工具，对 json 数据进行proto格式转换：
1. 安装 buf 工具：

```bash
GO111MODULE=on go install github.com/bufbuild/buf/cmd/buf@v1.32.2
```

2. 对 json 数据里的 traceId 和 spanId 进行 base64 加密替换：

```bash
echo "d5c1cb5ba7804dad6e6b743287d147ef" | xxd -r -p | base64
# output: 1cHLW6eATa1ua3Qyh9FH7w==
echo "b437939d3d19c621" | xxd -r -p | base64
# output: tDeTnT0ZxiE=
cp trace.json trace2.json
sed -i "" "s/d5c1cb5ba7804dad6e6b743287d147ef/1cHLW6eATa1ua3Qyh9FH7w==/g" trace2.json
sed -i "" "s/b437939d3d19c621/tDeTnT0ZxiE=/g" trace2.json
```

3. Json 转换成 protobuf：

```bash
git clone https://github.com/open-telemetry/opentelemetry-proto.git
buf convert opentelemetry-proto/ --type opentelemetry.proto.trace.v1.TracesData --from=trace2.json --to=trace.pb#format=binpb
curl -XPOST http://localhost:4318/v1/traces -H "content-type: application/x-protobuf" --data-binary "@trace.pb"
```

示例三：go 语言上报

请参考 https://github.com/fnless/otel_benchmark 的 main.go。

