class Point{
  
  public Point(float x, float y) {
    X = x;
    Y = y;
  }
  public float X;
  public float Y;
}

public class LineEquation
{
    public float A;
    public float B;

    private Segment _segment;

    public LineEquation(Segment segment)
    {
        this._segment = segment;
        this.Compute();
    }

    public void Compute()
    {
        A = (_segment.BPoint.Y - _segment.APoint.Y) / (_segment.BPoint.X - _segment.APoint.X);
        B = _segment.APoint.Y - (A * _segment.APoint.X);
    }
}

public class Segment
{

    private Point APoint;
    private Point BPoint;
    public LineEquation LineEquation;
    private double epsilon = 2.220446049250313E-16;

    public double GetLength()
    {
        return sqrt(pow(this.APoint.X - this.BPoint.X, 2) + pow(this.APoint.Y - this.BPoint.Y, 2));
    }

    public Segment(Point a, Point b)
    {
        APoint = a;
        BPoint = b;
        LineEquation = new LineEquation(this);
    }

    public boolean IsVertical()
    {
        return abs(this.APoint.X - this.BPoint.X) < 0;
    }

    public boolean IsHorizontal()
    {
        return abs(this.APoint.Y - this.BPoint.Y) < epsilon;
    }

    public boolean IsParallel(Segment bSegment)
    {
        return abs(this.LineEquation.A - bSegment.LineEquation.A) < epsilon && abs(this.LineEquation.B - bSegment.LineEquation.B) > epsilon;
    }

    public boolean GetIntersectionPoint(Segment bSegment, Point intersectionPoint)
    {
        if (this == bSegment)
        {
            return false;
        }
        else if (IsParallel(bSegment))
        {
            return false;
        }

        if (this.IsVertical() || bSegment.IsVertical())
        {
            Segment verticalSegment = this.IsVertical() ? this : bSegment;
            Segment otherSegment = this.IsVertical() ? bSegment : this;

            intersectionPoint.X = verticalSegment.APoint.X;
            intersectionPoint.Y = (otherSegment.LineEquation.A * verticalSegment.APoint.X) + otherSegment.LineEquation.B;
        }
        else if (IsHorizontal() || bSegment.IsHorizontal())
        {
            Segment horizontalSegment = this.IsHorizontal() ? this : bSegment;
            Segment otherSegment = this.IsHorizontal() ? bSegment : this;

            intersectionPoint.X = (horizontalSegment.LineEquation.B - otherSegment.LineEquation.B)
                              / (otherSegment.LineEquation.A - horizontalSegment.LineEquation.A);
            intersectionPoint.Y = horizontalSegment.APoint.Y;
        }
        else
        {
            intersectionPoint.X = (bSegment.LineEquation.B - this.LineEquation.B)
                              / (this.LineEquation.A - bSegment.LineEquation.A);
            intersectionPoint.Y = (this.LineEquation.A * intersectionPoint.X) + this.LineEquation.B;
        }

        boolean tmp = PointIsOnSegment(intersectionPoint);
        boolean tmp2 = bSegment.PointIsOnSegment(intersectionPoint);
        if (!tmp || !tmp2)
        {
            return false;
        }

        return true;
    }

      public boolean Intersect(Segment bSegment)
      {
          Point intersection = new Point(0,0);
          return this.GetIntersectionPoint(bSegment, intersection);
      }
        
    public boolean PointIsOnSegment(Point point)
    {
        return point.X >= min(APoint.X, BPoint.X) && point.X <= max(APoint.X, BPoint.X)
               && point.Y >= min(APoint.Y, BPoint.Y) && point.Y <= max(APoint.Y, BPoint.Y);
    }
}