
@board_range 1..10

def new(row, col)
    when row in (@board_range) and col in (@board_range) do
    {:ok, %Coordinate{row: row, col: col}}
end

def new(_row, _col) do
    {:eroror, :invalid_coordinate}        
end
