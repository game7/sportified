import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Col, ColProps, Row, Select, Space, Table } from "antd";
import dayjs from "dayjs";
import { ComponentProps } from "react";
import { LinkButton } from "../../../components/buttons/link-button";
import { HostLayout } from "../../../components/layout/host-layout";

interface Props extends App.SharedProps {
  by_controller: Record<string, number>;
  by_day: Record<string, number>;
  by_exception: Record<string, number>;
  by_host: Record<string, number>;
  exceptions?: App.Exception[];
}

function toList(object: Record<string, number>) {
  return Object.entries(object).map(([key, value]) => ({ key, value }));
}

function toOptions(
  object: Record<string, number>
): ComponentProps<typeof Select>["options"] {
  return Object.entries(object).map(([key, value]) => ({
    value: key,
    label: `${key} (${value})`,
  }));
}

const COL_PROPS: ColProps = {
  span: 12,
  xl: 6,
};

export default function HostExceptionsIndexPage() {
  const { by_controller, by_day, by_exception, by_host, exceptions } =
    usePage<Page<Props>>().props;
  const searchParams = new URLSearchParams(window.location.search);

  function makeUrl(param: string, value: string) {
    let url = new URL(window.location.toString());
    if (value) {
      url.searchParams.set(param, value);
    } else {
      url.searchParams.delete(param);
    }
    return url.toString();
  }

  function goto(param: string, value: string) {
    Inertia.get(makeUrl(param, value));
  }

  return (
    <HostLayout
      title="Exceptions"
      breadcrumbs={[{ href: "/host/exceptions", label: "Exceptions" }]}
      extra={[
        <LinkButton key="clear-filters" href={window.location.pathname}>
          Clear Filters
        </LinkButton>,
      ]}
    >
      <Space direction="vertical" size="large" style={{ display: "flex" }}>
        <Row gutter={[16, 16]}>
          <Col {...COL_PROPS}>
            <Select
              placeholder="Date"
              options={toOptions(by_day)?.reverse()}
              onChange={(value) => goto("date", value)}
              defaultValue={searchParams.get("date")}
              style={{ width: "100%" }}
              allowClear={true}
              showSearch
              filterOption={(input, option) =>
                (option?.value ?? "")
                  .toLowerCase()
                  .includes(input.toLowerCase())
              }
            />
          </Col>
          <Col {...COL_PROPS}>
            <Select
              placeholder="Controller/Action"
              options={toOptions(by_controller)}
              onChange={(value) => goto("route", value)}
              defaultValue={searchParams.get("route")}
              style={{ width: "100%" }}
              allowClear={true}
              showSearch
              filterOption={(input, option) =>
                (option?.value ?? "")
                  .toLowerCase()
                  .includes(input.toLowerCase())
              }
            />
          </Col>
          <Col {...COL_PROPS}>
            <Select
              placeholder="Exception"
              options={toOptions(by_exception)}
              onChange={(value) => goto("exception", value)}
              defaultValue={searchParams.get("exception")}
              style={{ width: "100%" }}
              allowClear={true}
              showSearch
              filterOption={(input, option) =>
                (option?.value ?? "")
                  .toLowerCase()
                  .includes(input.toLowerCase())
              }
            />
          </Col>
          <Col {...COL_PROPS}>
            <Select
              placeholder="Host"
              options={toOptions(by_host)}
              onChange={(value) => goto("hostname", value)}
              defaultValue={searchParams.get("hostname")}
              style={{ width: "100%" }}
              allowClear={true}
              showSearch
              filterOption={(input, option) =>
                (option?.value ?? "")
                  .toLowerCase()
                  .includes(input.toLowerCase())
              }
            />
          </Col>
        </Row>
        {!exceptions && (
          <Row gutter={[16, 16]}>
            <Col {...COL_PROPS}>
              <Table
                dataSource={toList(by_day).reverse().slice(0, 20)}
                rowKey={(record) => record.key}
                bordered
                size="small"
                columns={[
                  {
                    dataIndex: "key",
                    title: "Date",
                    render: (key) => (
                      <Link href={makeUrl("date", key)}>{key}</Link>
                    ),
                    ellipsis: true,
                  },
                  {
                    dataIndex: "value",
                    title: "Count",
                    align: "right",
                    width: "20%",
                  },
                ]}
                pagination={false}
              />
            </Col>
            <Col {...COL_PROPS}>
              <Table
                dataSource={toList(by_controller).slice(0, 20)}
                rowKey={(record) => record.key}
                bordered
                size="small"
                columns={[
                  {
                    dataIndex: "key",
                    title: "Controller",
                    render: (key) => (
                      <Link href={makeUrl("route", key)}>{key}</Link>
                    ),
                    ellipsis: true,
                  },
                  {
                    dataIndex: "value",
                    title: "Count",
                    align: "right",
                    width: "20%",
                  },
                ]}
                pagination={false}
              />
            </Col>
            <Col {...COL_PROPS}>
              <Table
                dataSource={toList(by_exception).slice(0, 20)}
                rowKey={(record) => record.key}
                bordered
                size="small"
                columns={[
                  {
                    dataIndex: "key",
                    title: "Exception",
                    render: (key) => (
                      <Link href={makeUrl("exception", key)}>{key}</Link>
                    ),
                    ellipsis: true,
                  },
                  {
                    dataIndex: "value",
                    title: "Count",
                    align: "right",
                    width: "20%",
                  },
                ]}
                pagination={false}
              />
            </Col>
            <Col {...COL_PROPS}>
              <Table
                dataSource={toList(by_host).slice(0, 20)}
                rowKey={(record) => record.key}
                bordered
                size="small"
                columns={[
                  {
                    dataIndex: "key",
                    title: "Host",
                    render: (key) => (
                      <Link href={makeUrl("hostname", key)}>{key}</Link>
                    ),
                    ellipsis: true,
                  },
                  {
                    dataIndex: "value",
                    title: "Count",
                    align: "right",
                    width: "20%",
                  },
                ]}
                pagination={false}
              />
            </Col>
          </Row>
        )}
        {exceptions && (
          <Table
            dataSource={exceptions}
            rowKey={(exc) => exc.id}
            columns={[
              {
                dataIndex: "id",
                title: "Id",
                width: "10%",
              },
              {
                dataIndex: "visit_id",
                title: "Visit Id",
                width: "10%",
              },
              {
                dataIndex: "time",
                title: "Date / Time",
                render: (time) => dayjs(time).format("YYYY-MM-DD HH:mm:ss Z"),
                ellipsis: true,
              },
              {
                dataIndex: ["properties", "params"],
                title: "Controller/Action",
                render: (params) => `${params.controller}#${params.action}`,
                ellipsis: true,
              },
              {
                dataIndex: ["properties", "exception"],
                title: "Exception",
                ellipsis: true,
              },
              {
                dataIndex: ["properties", "host"],
                title: "Host",
                ellipsis: true,
              },
            ]}
            bordered
          />
        )}
      </Space>
    </HostLayout>
  );
}
