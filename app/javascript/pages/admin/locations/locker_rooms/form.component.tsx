import { Group, Radio, Stack, TextInput } from "@mantine/core";
import { useForm } from "@mantine/form";
import { BackButton, SubmitButton } from "~/components/buttons";
import { actions } from "~/routes";
import { useBind } from "~/utils/use-bind";
import { usePage } from "~/utils/use-page";

type PageProps = {
  locker_room: App.LockerRoom;
  location: App.Location;
};

export function AdminLocationsLockerRoomsForm() {
  const { props } = usePage<PageProps>();
  const { locker_room, location } = props;

  const form = useForm<App.LockerRoom>({ initialValues: locker_room });
  const bind = useBind(form);

  function handleSubmit(data: Partial<App.LockerRoom>) {
    const payload = { locker_room: data };

    if (locker_room.id) {
      actions["next/admin/locations/locker_rooms"]["update"].patch(
        { id: locker_room.id.toString() },
        payload
      );
    } else {
      actions["next/admin/locations/locker_rooms"]["create"].post(
        { location_id: location.id },
        payload
      );
    }
  }

  return (
    <form onSubmit={form.onSubmit(handleSubmit)}>
      <Stack>
        <TextInput {...bind("name")} withAsterisk style={{ width: 200 }} />
        <Radio.Group {...bind("auto_assign")} withAsterisk>
          <Group>
            <Radio value="home" label="Home" />
            <Radio value="away" label="Away" />
            <Radio value="" label="None" />
          </Group>
        </Radio.Group>
        <Group spacing="xs">
          <SubmitButton></SubmitButton>
          <BackButton></BackButton>
        </Group>
      </Stack>
    </form>
  );
}
