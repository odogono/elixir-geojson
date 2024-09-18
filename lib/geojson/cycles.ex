defmodule GeoJSON.CycleExtractor do
  #   def extract_cycles(vertices, edges) do
  #     extract_cycles_recursive(vertices, edges, [])
  #   end

  #   defp extract_cycles_recursive([], _edges, cycles), do: cycles

  #   defp extract_cycles_recursive(vertices, edges, cycles) do
  #     v = left_bottom_vertex(vertices)
  #     walk = v |> closed_walk_from() |> reduce_walk()

  #     new_cycles = if length(walk) > 2, do: [walk | cycles], else: cycles
  #     {v1, v2} = {Enum.at(walk, 0), Enum.at(walk, 1)}

  #     new_edges = remove_edge(edges, v1, v2)

  #     new_vertices =
  #       vertices
  #       |> remove_filament_at(v1)
  #       |> remove_filament_at(v2)

  #     extract_cycles_recursive(new_vertices, new_edges, new_cycles)
  #   end

  #   defp left_bottom_vertex(vertices) do
  #     Enum.reduce(vertices, fn v, m ->
  #       dx = v.x - m.x

  #       cond do
  #         dx < 0 -> v
  #         dx > 0 -> m
  #         true -> if v.y - m.y < 0, do: m, else: v
  #       end
  #     end)
  #   end

  #   defp closed_walk_from(v) do
  #     {walk, _} =
  #       Enum.reduce_while(Stream.cycle([nil]), {[], v, nil}, fn _, {walk, curr, prev} ->
  #         walk = [curr | walk]
  #         {next, new_prev} = get_next(curr, prev)
  #         if next == v, do: {:halt, {walk, new_prev}}, else: {:cont, {walk, next, new_prev}}
  #       end)

  #     Enum.reverse(walk)
  #   end

  #   defp reduce_walk(walk) do
  #     Enum.reduce(1..length(walk), walk, fn i, w ->
  #       case Enum.drop(w, i) |> Enum.find_index(&(&1 == Enum.at(w, i))) do
  #         nil -> w
  #         idup -> List.delete_at(w, i + idup)
  #       end
  #     end)
  #   end

  #   defp remove_edge(edges, v1, v2) do
  #     Map.update!(edges, v1, &List.delete(&1, v2))
  #     |> Map.update!(v2, &List.delete(&1, v1))
  #   end

  #   defp remove_filament_at(vertices, v) do
  #     remove_filament_recursive(vertices, v, edges[v])
  #   end

  #   defp remove_filament_recursive(vertices, nil, _), do: vertices
  #   defp remove_filament_recursive(vertices, v, adj) when length(adj) >= 2, do: vertices

  #   defp remove_filament_recursive(vertices, v, adj) do
  #     new_vertices = List.delete(vertices, v)
  #     next = List.first(adj)
  #     new_edges = remove_edge(edges, v, next)
  #     remove_filament_recursive(new_vertices, next, new_edges[next])
  #   end

  #   defp get_next(v, prev) do
  #     adj = edges[v]

  #     next =
  #       if length(adj) == 1 do
  #         List.first(adj)
  #       else
  #         best_by_kind(prev, v, if(prev, do: :ccw, else: :cw))
  #       end

  #     {next, v}
  #   end

  #   defp best_by_kind(v_prev, v_curr, kind) do
  #     d_curr = if v_prev, do: vsub(v_curr, v_prev), else: %{x: 0, y: -1}
  #     adj = if v_prev, do: List.delete(edges[v_curr], v_prev), else: edges[v_curr]

  #     Enum.reduce(adj, fn v, v_so_far ->
  #       better_by_kind(v, v_so_far, v_curr, d_curr, kind)
  #     end)
  #   end

  #   defp better_by_kind(v, v_so_far, v_curr, d_curr, kind) do
  #     d = vsub(v, v_curr)
  #     d_so_far = vsub(v_so_far, v_curr)
  #     is_convex = dot_perp(d_so_far, d_curr) > 0
  #     curr2v = dot_perp(d_curr, d)
  #     vsf2v = dot_perp(d_so_far, d)

  #     v_is_better =
  #       case kind do
  #         :cw ->
  #           (is_convex and (curr2v >= 0 or vsf2v >= 0)) or
  #             (not is_convex and curr2v >= 0 and vsf2v >= 0)

  #         :ccw ->
  #           (not is_convex and (curr2v < 0 or vsf2v < 0)) or
  #             (is_convex and curr2v < 0 and vsf2v < 0)
  #       end

  #     if v_is_better, do: v, else: v_so_far
  #   end

  #   defp vsub(a, b) do
  #     %{x: a.x - b.x, y: a.y - b.y}
  #   end

  #   defp dot_perp(a, b) do
  #     a.x * b.y - b.x * a.y
  #   end
end
