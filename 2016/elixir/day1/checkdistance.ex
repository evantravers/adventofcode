input = with { :ok, file } = File.open( "instructions.txt" ),
             line = IO.read( file, :line ),
             :ok = File.close( file )
        do
          String.replace( line, "\n", "" )
          |> String.split( ", " )
          |> Enum.map( fn direction ->
            { dir, val } = String.split_at( direction, 1 )
            { dir, String.to_integer( val ) }
          end )
        end

defmodule One do


  def run( instructions ) do
    step instructions, %{ x: 0, y: 0, direction: [ 0, 1 ] }
  end

  defp step( [], result ), do: result
end
