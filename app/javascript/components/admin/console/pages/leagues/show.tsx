import React, { FC, useEffect, useState } from 'react';
import Layout from '../../components/layout'
import { League, find } from '../../actions/leagues'
import { Season }  from '../../actions/seasons'
import { Division } from '../../actions/divisions'
import { Team, list as listTeams } from '../../actions/teams'
import { RouteComponentProps, Link } from 'react-router-dom'
import { Table, Dropdown, Image, Header } from 'semantic-ui-react'
import { asc, desc } from '../../utils/sort'
import { group, n } from '../../utils'
import { ActionsDropdown } from '../../components/actions-dropdown'

export const LeaguesUpdate: FC<RouteComponentProps<{ id: number, seasonId?: number }>> = ({ match, history }) => {
  const {
    id,
    seasonId = 0
  } = match.params
  // const [loading, setLoading] = useState(false)
  const [league, setLeague] = useState<League>()
  const [teams, setTeams] = useState<Team[]>()

  const seasons = league ? desc(league.seasons, "createdAt") : []
  const season = league ? seasons.find(s => s.id == seasonId) || seasons[0] : null
  const divisions = league ? asc(league.divisions.filter(d => season.divisionIds.some(id => id == d.id)), "name") : []

  useEffect(() => {
    (async function loadLeague() {
      setLeague(await find({ id, include: ["divisions", "seasons"] }))
    })()
  }, [])

  useEffect(() => {
    if(!season) { return }
    (async function loadTeams() {
      setTeams(await listTeams({ seasonId: season.id }))
    })()
  }, [season])
  
  const loading = !(league && teams)

  const actions = (
    <SeasonsMenu current={season} seasons={seasons} />
  )
  return (
    <Layout title={league ? league.name : ""} actions={actions} loading={loading}>
      {divisions.map(division => (
        <DivisionTable key={division.id} division={division} teams={teams || []} />
      ))}
    </Layout>
  )
}

const DivisionTable: FC<{ division: Division, teams: Team[] }> = (props) => {
  const { division } = props
  const teams = asc(props.teams.filter(team => team.divisionId == division.id), "name")

  return (
    <Table columns={3} celled>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell colSpan={3}>
            {division.name}
            <div style={{ float: 'right' }} >
              <ActionsDropdown>
                <Dropdown.Item as={Link} to={`/divisions/${division.id}/edit`} icon="cog" text="Settings" />
              </ActionsDropdown>
            </div>
          </Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {group(teams).by(3).map((row, i) => (
          <Table.Row key={i}>
            {row.items.map((team, i) => (
              <Table.Cell key={i}>
                <Header as="h4" image style={{ marginBottom: 0 }}>
                  <Image src={team.avatarUrl || '/image.png'} rounded size='mini' />
                  <Header.Content>{team.name}</Header.Content>
                </Header>
                <div style={{ float: 'right' }}>
                  <ActionsDropdown>
                    <Dropdown.Item as={Link} to={`/teams/${team.id}`} icon="users" text="Show" />
                    <Dropdown.Item as={Link} to={`/teams/${team.id}/edit`} icon="edit" text="Edit" />
                  </ActionsDropdown>
                </div>
              </Table.Cell>
            ))}
            {n(row.blanks).times((i) => (
              <Table.Cell key={i}>
                {" "}
              </Table.Cell>
            ))}
          </Table.Row>
        ))}
      </Table.Body>
      {/* <Table.Body>
        {teams.map(team => (
          <Table.Row key={team.id}>
            <Table.Cell>{team.name}</Table.Cell>
          </Table.Row>
        ))}
      </Table.Body> */}
    </Table>
  )
}

const SeasonsMenu: FC<{ current: Season, seasons: Season[] }> = ({ current, seasons }) => {
  if(!current) { return null }
  const more = seasons.length > 5
  const recent = desc(seasons, "createdAt").slice(0, 5)
  return (
    <Dropdown button text={current.name}>
      <Dropdown.Menu>
        <Dropdown.Header content="Season"/>
        <Dropdown.Item icon="edit" content="Edit" as={Link} to={`/seasons/${current.id}/edit`}/>
        <Dropdown.Divider/>
        <Dropdown.Header content="Other Seasons"/>
        {recent.map(season => (
          <Dropdown.Item key={season.id} text={season.name} as={Link} to={`/leagues/${season.programId}/seasons/${season.id}`} />
        ))}
        {more && (
          <Dropdown.Item text="All Seasons" as={Link} to={`/leagues/${current.programId}/seasons`} />
        )}
      </Dropdown.Menu>
    </Dropdown>
  )
}

export default LeaguesUpdate;

