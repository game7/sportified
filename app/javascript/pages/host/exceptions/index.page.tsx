import { Inertia, Page } from "@inertiajs/inertia";
import { Link, usePage } from "@inertiajs/inertia-react";
import { Grid, Select, Stack, Table } from "@mantine/core";
import dayjs from "dayjs";
import { DataGrid } from "mantine-data-grid";
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
): ComponentProps<typeof Select>["data"] {
  return Object.entries(object).map(([key, value]) => ({
    value: key,
    label: `${key} (${value})`,
  }));
}

export default function HostExceptionsIndexPage() {
  const { by_controller, by_day, by_exception, by_host, exceptions } =
    usePage<Page<Props>>().props;
  const searchParams = new URLSearchParams(window.location.search);

  function makeUrl(param: string, value: string | null) {
    let url = new URL(window.location.toString());
    if (value) {
      url.searchParams.set(param, value);
    } else {
      url.searchParams.delete(param);
    }
    return url.toString();
  }

  function goto(param: string, value: string | null) {
    Inertia.get(makeUrl(param, value));
  }

  const Col = (props: ComponentProps<typeof Grid.Col>) => (
    <Grid.Col md={6} {...props} />
  );

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
      <Stack>
        <Grid>
          <Col>
            <Select
              placeholder="Date"
              data={Array.from(toOptions(by_day)).reverse()}
              onChange={(value) => goto("date", value)}
              defaultValue={searchParams.get("date")}
              style={{ width: "100%" }}
              clearable
              searchable
            />
          </Col>
          <Col>
            <Select
              placeholder="Controller/Action"
              data={toOptions(by_controller)}
              onChange={(value) => goto("route", value)}
              defaultValue={searchParams.get("route")}
              style={{ width: "100%" }}
              clearable
              searchable
            />
          </Col>
          <Col>
            <Select
              placeholder="Exception"
              data={toOptions(by_exception)}
              onChange={(value) => goto("exception", value)}
              defaultValue={searchParams.get("exception")}
              style={{ width: "100%" }}
              clearable
              searchable
            />
          </Col>
          <Col>
            <Select
              placeholder="Host"
              data={toOptions(by_host)}
              onChange={(value) => goto("hostname", value)}
              defaultValue={searchParams.get("hostname")}
              style={{ width: "100%" }}
              clearable
              searchable
            />
          </Col>
        </Grid>
        {!exceptions && (
          <Grid>
            <Col>
              <Table withBorder withColumnBorders>
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Count</th>
                  </tr>
                </thead>
                <tbody>
                  {toList(by_day)
                    .reverse()
                    .slice(0, 20)
                    .map(({ key, value }) => (
                      <tr>
                        <td>
                          <Link href={makeUrl("date", key)}>{key}</Link>
                        </td>
                        <td align="right" width="20%">
                          {value}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </Table>
            </Col>
            <Col>
              <Table withBorder withColumnBorders>
                <thead>
                  <tr>
                    <th>Controller</th>
                    <th>Count</th>
                  </tr>
                </thead>
                <tbody>
                  {toList(by_controller)
                    .slice(0, 20)
                    .map(({ key, value }) => (
                      <tr>
                        <td>
                          <Link href={makeUrl("route", key)}>{key}</Link>
                        </td>
                        <td align="right" width="20%">
                          {value}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </Table>
            </Col>
            <Col>
              <Table withBorder withColumnBorders>
                <thead>
                  <tr>
                    <th>Controller</th>
                    <th>Count</th>
                  </tr>
                </thead>
                <tbody>
                  {toList(by_exception)
                    .slice(0, 20)
                    .map(({ key, value }) => (
                      <tr>
                        <td>
                          <Link href={makeUrl("exception", key)}>{key}</Link>
                        </td>
                        <td align="right" width="20%">
                          {value}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </Table>
            </Col>
            <Col>
              <Table withBorder withColumnBorders>
                <thead>
                  <tr>
                    <th>Controller</th>
                    <th>Count</th>
                  </tr>
                </thead>
                <tbody>
                  {toList(by_host)
                    .slice(0, 20)
                    .map(({ key, value }) => (
                      <tr>
                        <td>
                          <Link href={makeUrl("hostname", key)}>{key}</Link>
                        </td>
                        <td align="right" width="20%">
                          {value}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </Table>
            </Col>
          </Grid>
        )}
        {exceptions && (
          <DataGrid
            styles={(theme) => ({
              thead: {
                "::after": {
                  backgroundColor: "transparent",
                },
              },
            })}
            withBorder
            withColumnBorders
            data={exceptions}
            columns={[
              {
                header: "Id",
                accessorKey: "id",
                cell: (cell) => (
                  <Link href={`/host/events/${cell.getValue<number>()}`}>
                    {cell.getValue<number>()}
                  </Link>
                ),
              },
              {
                header: "Visit Id",
                accessorKey: "visit_id",
                cell: (cell) => (
                  <Link href={`/host/visits/${cell.getValue<number>()}`}>
                    {cell.getValue<number>()}
                  </Link>
                ),
              },
              {
                header: "Date / Time",
                accessorFn: (exception) =>
                  dayjs(exception.time).format("YYYY-MM-DD HH:mm:ss Z"),
              },
              {
                header: "Controller / Action",
                accessorFn: ({ properties: { params } }) =>
                  `${params.controller}#${params.action}`,
              },
              {
                header: "Exception",
                accessorFn: ({ properties }) => properties.exception,
              },
              {
                header: "Host",
                accessorFn: ({ properties }) => properties.host,
              },
            ]}
          ></DataGrid>
        )}
      </Stack>
    </HostLayout>
  );
}
